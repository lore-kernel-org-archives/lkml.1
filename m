Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYG2Swb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYG2Swb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYG2SwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:52:21 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62051 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYG2SwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:52:20 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <488F524F.6020905@redhat.com>
	<20080729182611.GB24924@parisc-linux.org>
	<1217356645.6103.48.camel@localhost.localdomain>
Date: Tue, 29 Jul 2008 14:48:31 -0400
In-Reply-To: <1217356645.6103.48.camel@localhost.localdomain> (James Bottomley's message of "Tue\, 29 Jul 2008 13\:37\:25 -0500")
Message-ID: <yq13alsr0g0.fsf@sermon.lab.mkp.net>
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

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> The problem, which ata_ram also suffers, is that the tools we
James> most need to test are the ones for manipulating non volatile
James> characteristics (like partition tables).  We'd really like the
James> disk contents to survive reboot for this ...

Yeah, I should add that I wanted persistence too.  I went through a
whole stack (well, 5-6 or so) fibre channel drives from various
vendors and attempted to low-level format them to 4KB sectors.  Most
of them laughed in my face.  One of them tried to comply and
irreparably confused its firmware in the process.

Just yesterday I received a couple of prototype drives in the mail.
I'll ask the vendor whether they support 4KB and if so I'll give them
a whirl.

-- 
Martin K. Petersen	Oracle Linux Engineering

