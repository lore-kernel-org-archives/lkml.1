Return-Path: <linux-kernel-owner+w=401wt.eu-S965152AbZLQPTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbZLQPTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965079AbZLQPTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:19:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55334 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965138AbZLQPTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Fey0yammuVFS/DPesLmz/9N43X97iF2NVrcdDyf7sIpOZqBEDecJvq7fKUGYvhS12/
         ij0UMO5zV/2HqWL87erw56I+KZ5VxsfXiFt4xhLCzG/s9069pPM//tFwTaZqoCA2ZrN5
         HHvGfr1jotF10nSApSdPpitDabjk53lUisN9s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 16:18:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com> <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912170713390.17868@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912171618.32882.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 04:14:37 pm Linus Torvalds wrote:
> 
> On Thu, 17 Dec 2009, Américo Wang wrote:
> > 
> > I like this patch, this is actually what I wanted to do.
> 
> I have nothing against a switch, but it had better default to off.
> 
> The whole 80-char limit is insane. It results in insane "fixes". Just 
> about every time somebody "improves" a patch due to the warning, the 
> result is worse than the original patch.

Examples? :)

--
Bartlomiej Zolnierkiewicz
