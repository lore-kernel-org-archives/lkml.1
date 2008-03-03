Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYCCOoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYCCOoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYCCOnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:43:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37141 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYCCOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:43:52 -0500
Date: Mon, 3 Mar 2008 15:11:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Pawel Plociennik <paplociennik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
Message-ID: <20080303141100.GA12606@elf.ucw.cz>
References: <200803011409.59526.paplociennik@gmail.com> <3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0803020800m6ef56c7enc5e9b28852266c9f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Sat, Mar 1, 2008 at 8:09 PM, Pawel Plociennik <paplociennik@gmail.com> wrote:
> >  In the short this patch has added a new chroot= kernel parameter which can be used
> >  to changing a chroot of an init process before it will has been runed.
> 
> Wouldn't booting with 'init=/usr/sbin/chroot /path /sbin/init' achieve
> the same effect?
> Haven't tested it, just wondering.

This breaks down when there's no distribution installed in /, or when
distro in / is badly broken.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
