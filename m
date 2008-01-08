Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYAHN0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYAHN0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbYAHN0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:26:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:58000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814AbYAHN0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:26:21 -0500
Date: Tue, 8 Jan 2008 14:26:10 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Bodo Eggert <7eggert@gmx.de>, Ingo Oeser <ioe-lkml@rameria.de>,
       Bernd Schubert <bernd-schubert@gmx.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: sleep before boot panic
In-Reply-To: <20080107150349.GA6523@ucw.cz>
Message-ID: <alpine.LSU.0.999.0801081424230.12636@be1.lrz>
References: <9II6K-1Pg-9@gated-at.bofh.it> <9IJ2M-3l2-3@gated-at.bofh.it>
 <9IJme-3Nb-13@gated-at.bofh.it> <9IKrY-5vk-15@gated-at.bofh.it>
 <E1JBqS9-0003Xp-Sh@be1.7eggert.dyndns.org> <20080107150349.GA6523@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18Xsn83cTVvW6BQRZmi9sBwuW5oosD4SlDo/g4
 XAf+l/+k85aASs4NyVPijP0ICLZkFv/d3ebAe9pDJf4u0rdMXT
 mSeGUhGdOsiVuOiByejGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008, Pavel Machek wrote:

> > Introduce config CONFIG_SOFTPANIC
> > Enabling this option changes a hard panic on boot errors to a
> > soft panic, which does not stop the system completely.
> > You can still scroll the screen and read the messages.
> > 
> > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> 
> Looks good to me... but should this be configurable? IMO we should
> just do the right thing.

Having it configurable doesn't cost much, and the embedded folks without a 
screen certainly don't need this code.
-- 
Funny quotes:
23. If at first you don't succeed, destroy all evidence that you tried.
