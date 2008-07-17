Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbYGQTgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbYGQTgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbYGQT3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:29:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:4581 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbYGQT3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X04TWe+iQLeoo8CCdBeL5nfsbiGbkaEqWHa+H6w4Gtaf6oubIXr/hG8S6uO90Coea7
         CFSkjCAhD86QjteYVthxdMsgZWMKyfT2kG9E4e/OEyc+6bUhwVkvNLA+q6dgul1kRF8l
         ToHPMpGJdJtgIvtQZvdaIIV+6bTIB3fvsPpv0=
Message-ID: <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
Date: Thu, 17 Jul 2008 21:29:39 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Subject: Re: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
Cc: "Tim Shimmin" <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, "Johannes Weiner" <hannes@saeurebad.de>
In-Reply-To: <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com>
	 <487F980F.7070708@redhat.com>
	 <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 9:18 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Thanks, you are right. I have adjusted my configuration, but I am
> still able to produce this:
>
> BUG: unable to handle kernel paging request at b62a66e0
> IP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490

FWIW, this is fs/xfs/xfs_alloc.c:1817:

        if (!pag->pagf_init) {


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
