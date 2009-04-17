Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbZDQWwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbZDQWwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbZDQWwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:52:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZDQWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:52:29 -0400
Message-ID: <49E90684.6020707@zytor.com>
Date: Fri, 17 Apr 2009 15:45:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Szabolcs Szakacsits <szaka@ntfs-3g.com>
CC: Jeff Garzik <jeff@garzik.org>, Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com> <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <49E45E9C.1020105@redhat.com> <49E46437.5000804@garzik.org> <49E46779.1040106@redhat.com> <49E47744.3040103@garzik.org> <Pine.LNX.4.62.0904141447520.13379@tamago.serverit.net>
In-Reply-To: <Pine.LNX.4.62.0904141447520.13379@tamago.serverit.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Szabolcs Szakacsits wrote:
>>>
>>> Windows 2008 aligns partitions on a 1MB boundary, IIRC.
>> Makes a lot of sense...
> 
> Since Vista at least the first partition is 2048 sector aligned.
> 
> 	Szaka
> 

2048 * 512 = 1 MB, yes.

I *think* it's actually 1 MB and not 2048 sectors, but yes, they've 
finally dumped the idiotic DOS misalignment.  Unfortunately the GNU 
parted people have said that the parted code is too fragile to fix 
parted in this way.  Sigh.

	-hpa
