Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXLLSzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXLLSzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXLLSys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:54:48 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:65067 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXLLSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=FKm4seyKk4mhT6i7EB897PGY0IsbsNDnrJWlLm9CPRTLe33CNbEq+d9m/ETbiuxSAXe8OKQ+VVG/80jj0O6lUBxjmBo3tO05MP9ONyiTO9/gUeCgPuJW7e7TTk96JU8D4PQ1mV/0JwJt7yulQA2rmdpzlCYwKME1WZMiwbv4XCM=
Date: Wed, 12 Dec 2007 19:54:52 +0100
To: Paul Mundt <lethal@linux-sh.org>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Dmitry <dmitry.torokhov@gmail.com>,
       linux-input-list <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [HP6XX/FIX/PATCH] - Fix bad default keymap in HP Jornada 6xx
 keyboard driver
Message-Id: <20071212195452.d854ea6f.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071212184558.GA16129@linux-sh.org>
References: <20071212192207.196f18cc.Kristoffer.ericson@gmail.com>
	<20071212184558.GA16129@linux-sh.org>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 03:45:58 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Wed, Dec 12, 2007 at 07:22:07PM +0100, Kristoffer Ericson wrote:
> > shortlog:
> > * This patch fixes the HP Jornada 6xx keyboard default keymap which had some bad keymap values. This resulted in wrong
> > key being returned when pressed (example : key y returned 'r').
> > * Also, while we are at it lets arrange the include files in alphabetical order.
> > 
> You do realize that the default keymap was written for the Japanese units
> and the Japanese keyboards, right? From the looks of it, you are just
> trying to swap one functional set for another. I can assure you that this
> keymap worked fine on the Japanese units, so calling it a bug is a bit
> misleading.

Mostly true yes. However a few errors entered simply due to me copying the keymap poorly in the initial keymap. So it does infact have 'bug' keys that wouldn't work properly on neither japanese / european / US jornadas. And whatever functional set, this patch fixes those
bugs.


