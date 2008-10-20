Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbYJTO6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbYJTO6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYJTO6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:58:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46459 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYJTO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HfiO15nnQ446lqIQYV+Vfu7PN1c6b/X2I3LP3N0qT0t0Qj2+qEWfCdkzffIfwdom+4
         EC3yI1cu5zvUVpQVr14hsXFomwL4ss2oFTK+kif5pQbYvnYY6DTJ1SS2ZicWMaERB3fc
         ChlN5SiTOKBFAVrVtKCyoz4UrLokLt+IS01pE=
Message-ID: <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
Date: Mon, 20 Oct 2008 18:58:09 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Cc: "Christoph Hellwig" <hch@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081017135510.7127c4e7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
	 <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <20081017165738.GA20818@infradead.org>
	 <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	 <20081017203710.GA27187@infradead.org>
	 <20081017135510.7127c4e7@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/18 Arjan van de Ven <arjan@infradead.org>:
> On Fri, 17 Oct 2008 16:37:10 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> I just ran the xfs testsuite over linux-next on qemu (i386), and I
>> can't find anything at all.  Really strange.  Let's see if this still
>> there with mondays linux-next, and if yes can you just try the xfs
>> patch from the splitout linux-next patches and see if that alone
>> causes it?

Hi Christoph

I have the same result with next-1020 and today's xfs-2.6.git/master
(
commit bfd2bd10da76378dc4afd87d7d204a1d3d70b347
Author: David Chinner <david@fromorbit.com>
Date:   Fri Oct 17 15:36:23 2008 +1000
    Inode: Allow external list initialisation
)

Should I start bisecting?
>>
>> In fact that might be useful for todays linux-next, too.
>> --
>
> also if you enable lockdep, it tracks where irq's got turned off (with
> a stacktrace I think) so it would provide some good clues.

Yes, lockdep was enabled, but there is no more information than I
already posted.
