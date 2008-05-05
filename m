Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYEEHjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYEEHjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYEEHjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:39:11 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:42534 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYEEHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:39:10 -0400
Message-ID: <18462.47505.453068.931094@ipc1.ka-ro>
Date: Mon, 5 May 2008 09:38:57 +0200
From: =?iso-8859-15?q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Willy Tarreau <w@1wt.eu>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount point inside a read only filesystem
In-Reply-To: <20080505072824.GE14635@1wt.eu>
References: <18456.34604.472989.35082@ipc1.ka-ro>
	<20080501215231.297e0d9d.akpm@linux-foundation.org>
	<53722.192.168.1.70.1209711343.squirrel@neil.brown.name>
	<20080503063231.GA688@1wt.eu>
	<18462.43245.728465.911831@ipc1.ka-ro>
	<20080505070214.GA14635@1wt.eu>
	<18462.45648.60033.233887@ipc1.ka-ro>
	<20080505072824.GE14635@1wt.eu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Willy Tarreau writes:
> > Interestingly your strace output showed a return value of EEXIST where
> > mine had EROFS.
> 
> Oh you're right! I did not notice. There's something odd here.
> And I can reproduce it right now (2.6.25.1). I really have
> EEXIST.
> 
As I noted in my first message I have this problem with the kernel
from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
which is currently 2.6.26-rc1 and still exhibits this behaviour.

So, this problem obviously does not exist in the 2.6.25 release kernel
but would probably hit mainline in the 2.6.26 release.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
