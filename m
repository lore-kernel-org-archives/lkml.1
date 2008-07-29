Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYG2Sna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYG2Sna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYG2SnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:43:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57634 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYG2SnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:43:15 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <488F524F.6020905@redhat.com>
	<20080729182611.GB24924@parisc-linux.org>
Date: Tue, 29 Jul 2008 14:41:47 -0400
In-Reply-To: <20080729182611.GB24924@parisc-linux.org> (Matthew Wilcox's message of "Tue\, 29 Jul 2008 12\:26\:11 -0600")
Message-ID: <yq17ib4r0r8.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> I'll admit to having not tested it with anything other than
Matthew> 512, but it ought to support 4096 byte sectors just fine.  I
Matthew> haven't looked at what would be required to support 520-byte
Matthew> sectors.

I recently added multiple sector support to scsi_debug.  On a recent
kernel you can modprobe scsi_debug sector_size=4096.

I have only tested 4KB but it also supports 1 and 2KB.

-- 
Martin K. Petersen	Oracle Linux Engineering

