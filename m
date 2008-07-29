Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYG2SzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYG2SzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYG2Syu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:54:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYG2Sys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:54:48 -0400
Message-ID: <488F6758.8080907@redhat.com>
Date: Tue, 29 Jul 2008 14:54:16 -0400
From: Ric Wheeler <rwheeler@redhat.com>
Reply-To: rwheeler@redhat.com
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
References: <488F524F.6020905@redhat.com>	<20080729182611.GB24924@parisc-linux.org>	<1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq13alsr0g0.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>>>>>>             
>
> James> The problem, which ata_ram also suffers, is that the tools we
> James> most need to test are the ones for manipulating non volatile
> James> characteristics (like partition tables).  We'd really like the
> James> disk contents to survive reboot for this ...
>
> Yeah, I should add that I wanted persistence too.  I went through a
> whole stack (well, 5-6 or so) fibre channel drives from various
> vendors and attempted to low-level format them to 4KB sectors.  Most
> of them laughed in my face.  One of them tried to comply and
> irreparably confused its firmware in the process.
>
> Just yesterday I received a couple of prototype drives in the mail.
> I'll ask the vendor whether they support 4KB and if so I'll give them
> a whirl.
>   
Isn't this a great use case for a SCSI target device where our target 
can be a software disk on a remote host? What is missing for us to put 
something like that together?

ric

