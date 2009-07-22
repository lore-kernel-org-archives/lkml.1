Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZGVQTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZGVQTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZGVQTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:19:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49991 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbZGVQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:19:09 -0400
Date: Wed, 22 Jul 2009 17:19:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Simon Braunschmidt <sb@emlix.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: Handling multiple watchdogs
Message-ID: <20090722171920.505ffc4b@lxorguk.ukuu.org.uk>
In-Reply-To: <4A672B97.1070704@emlix.com>
References: <4A672B97.1070704@emlix.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 17:09:11 +0200
Simon Braunschmidt <sb@emlix.com> wrote:

> Hi
> 
> I have two watchdogs on my board that I both want to handle. What would 
> be the proper approach in this case?

Fixing the watchdog core to create a class of watchdog drivers and
treating the existing /dev/watchdog as a back compatibility hack. It's
been talked about for a very long time but not done, although I believe
Wim had some test code at one point ?

Alan
