Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZGRLtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZGRLtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbZGRLth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:49:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60538 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZGRLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:49:35 -0400
Date: Sat, 18 Jul 2009 13:49:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PM: resume devices took 9.176 seconds
Message-ID: <20090718114913.GF1433@ucw.cz>
References: <4A52247B.4040204@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52247B.4040204@fisher-privat.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-06 18:21:15, Alexey Fisher wrote:
> Hallo all,
> it testing a lot git tree especially suspend and resume. With my new  
> Intel DG45ID board i get always this trace:
>
> ============================================
> [  176.763922] PM: resume devices took 9.176 seconds
> [  176.763924] ------------[ cut here ]------------
> [  176.763930] WARNING: at kernel/power/suspend_test.c:52  
> suspend_test_finish+0x7c/0x80()
>
> this is related with the commit:
>    commit 77437fd4e61f87cc94d9314baa5cbf50e3ccdf54
> Author: David Brownell <dbrownell@users.sourceforge.net>
> Date:   Wed Jul 23 21:28:33 2008 -0700
>
> probobly it's depend  on this message:
> [  173.076075] ata1: link is slow to respond, please be patient (ready=0)
>
> so it's looks normal for this board and harddrive. I think it should be  
> some way to change default TEST_SUSPEND_SECONDS by .config or  
> kernel-parameter. I changed default settings to 10 in  
> kernel/power/suspend_test.c but this is not the way it should be done.

I'm not sure if that's normal. Does it also delay on boot?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
