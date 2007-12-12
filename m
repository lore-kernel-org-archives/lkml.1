Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbXLLSqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbXLLSqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbXLLSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:46:08 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:35404 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758778AbXLLSqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:46:06 -0500
Date: Thu, 13 Dec 2007 03:45:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Dmitry <dmitry.torokhov@gmail.com>,
       linux-input-list <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [HP6XX/FIX/PATCH] - Fix bad default keymap in HP Jornada 6xx keyboard driver
Message-ID: <20071212184558.GA16129@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	Dmitry <dmitry.torokhov@gmail.com>,
	linux-input-list <linux-input@atrey.karlin.mff.cuni.cz>,
	linux-main <linux-kernel@vger.kernel.org>
References: <20071212192207.196f18cc.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212192207.196f18cc.Kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 07:22:07PM +0100, Kristoffer Ericson wrote:
> shortlog:
> * This patch fixes the HP Jornada 6xx keyboard default keymap which had some bad keymap values. This resulted in wrong
> key being returned when pressed (example : key y returned 'r').
> * Also, while we are at it lets arrange the include files in alphabetical order.
> 
You do realize that the default keymap was written for the Japanese units
and the Japanese keyboards, right? From the looks of it, you are just
trying to swap one functional set for another. I can assure you that this
keymap worked fine on the Japanese units, so calling it a bug is a bit
misleading.
