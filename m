Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbXEBUv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbXEBUv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXEBUv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:51:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:30545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXEBUv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YpAvAuDFLmhEcUibtTF+8OIeQz/CueypGNr54dmHxQB1M2bGT+MC60dlaj8G8yMjVwkfSKz4Je8XPh375rK6NRHaDhRGS6/SMR+dPKBVEIYw1rGSwE0r3uflpm7f+WLC/XN5UGOl7pDL3rbqzF4KM0KeTjjbb/zU0MNAkDdqfhs=
Message-ID: <f058a9c30705021351i24c7adc2i4c7e8a76e3b8d1bb@mail.gmail.com>
Date: Wed, 2 May 2007 21:51:50 +0100
From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: FEATURE REQUEST: merge MD software raid and LVM in one unique layer.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070502221045.ad20b915.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>
	 <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>
	 <20070502221045.ad20b915.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Diego Calleja <diegocg@gmail.com> wrote:
> El Wed, 2 May 2007 20:18:55 +0100, "Miguel Sousa Filipe" <miguel.filipe@gmail.com> escribió:
>
> > I find it high irritanting having two kernel interfaces and two
> > userland tools that provide the same funcionality, which one should I
> > use?
>
> I doubt users care about kernel's design; however the lack of unification of
> userspace tools is a real problem. Just my 2¢.
>

I believe they do, since the kernels desing obviate the need and use
of several diferent tools (that shouldn't be needed) like for instance
for having raid5 with snapshot and dinamic partition resizing we will
allways need:

md-raid5
lvm
some FS.

This md-raid5 and lvm separation is the evidence of how the kernels
design & API affect usability and userspace tools that the user is
obliged to use. I cannot have those features without "bumping" into
this kernel design issue.
 This is also a problem for any developer who tries to improve
usability in this area by creating some unified userland tools to
manipulate MD & LVM. (Imagining myself implementing some userland tool
to create some "storage devices" + mount points.. doesn't  seem easy
nor fun..).


Best regards,

-- 
Miguel Sousa Filipe
