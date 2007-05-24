Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbXEXJpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbXEXJpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXEXJpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:45:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:50763 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbXEXJpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=l/d0IZ5Nlv6r/kMLb7iPhM4RDcleH7dq4GL/oBdTcH0hqYyDKLvmmVqg21y6y8ED9iMWl4LyizKomkZFxQdrLoMPwjKeJ/i3s1V8NtfUehqGCvkSIBwHhh2l69fuStrU4C2CglHgctJE57EpRBJg+Peh4eU/vIwJoqfLDXINDbk=
Message-ID: <2cd57c900705240245s5448257ape203deade7812121@mail.gmail.com>
Date: Thu, 24 May 2007 17:45:04 +0800
From: "Qi Yong" <qiyong@fc-cn.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH - 1/1] Documentation/HOWTO
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "debian developer" <debiandev@gmail.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org, diegocg@gmail.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <10867.1179509181@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f24d23310705180629x50c56ayfdcde357f0373fc4@mail.gmail.com>
	 <Pine.LNX.4.64.0705181200440.18186@localhost.localdomain>
	 <10867.1179509181@turing-police.cc.vt.edu>
X-Google-Sender-Auth: 991ea269a0632f94
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/05/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 18 May 2007 12:01:41 EDT, "Robert P. J. Day" said:
> > On Fri, 18 May 2007, debian developer wrote:
>
> > > -your skills, and other developers will be aware of your presence. Fixing
> > > bugs is one of the best ways to get merits among other developers, because
> > > not many people like wasting time fixing other people's bugs.
> >                        ^^^^^^^ ^^^^
> > you might want to find a less demeaning term for debugging than
> > "wasting time."  just a thought.
>
> Wasn't his text, not his fault.  At least his patch is an improvement - now
> HOWTO only equates it with "wasting time" once, rather than twice. ;)

Hello,

This duplicated paragraph problem was introduced by the following two
commits. They are one patch actually.

bughunting patch adds bug; isn't it a vivid ironic example.

and also
> +not many people like wasting time fixing other people's bugs.

Torvalds, Care to revert one commit?

commit 722385f75efd82d9f480f0765a1e97a4d83cac0d
Author: Diego Calleja <diegocg@gmail.com>
Date:   Thu Sep 21 22:37:10 2006 +0200

    HOWTO: bug report addition

    I suspect that not many people is subscribed to the bugzilla mailing list,
    not surprising since the URLs doesn't seem to be in the tree :)

    After fixing my english, I wonder if the following patch could be applied...

    Signed-off-by: Diego Calleja <diegocg@gmail.com>
    Acked-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 3f27100872b21e4cc70d07b96eeb3611b30bce63
Author: Diego Calleja <diegocg@gmail.com>
Date:   Sat Sep 30 23:27:49 2006 -0700

    [PATCH] HOWTO: mention bughunting

    Signed-off-by: Diego Calleja <diegocg@gmail.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>


-- 
Qi Yong
