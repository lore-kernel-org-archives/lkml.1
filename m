Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbXIEPOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbXIEPOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXIEPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:14:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:47103 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751225AbXIEPOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:14:22 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19anJw00PdabEG7pdJwoNrtn0vLO49i78BpgDr4Pb
	UFN59yKFnD6tSs
Date: Wed, 5 Sep 2007 17:15:36 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: noah <noah123@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Rescanning SCSI/SATA bus
Message-ID: <20070905151536.GA13021@atjola.homenet>
References: <Pine.LNX.4.64.0709051140130.5419@fbirervta.pbzchgretzou.qr> <yq1zm01l0co.fsf@sermon.lab.mkp.net> <d00698fb0709050704j1014b87al20cfb451ac609e81@mail.gmail.com> <20070905142600.GA12798@atjola.homenet> <d00698fb0709050745p820f0ednf6592b142d1e409c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d00698fb0709050745p820f0ednf6592b142d1e409c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.09.05 16:45:29 +0200, noah wrote:
> 2007/9/5, Björn Steinbrink <B.Steinbrink@gmx.de>:
> > On 2007.09.05 16:04:13 +0200, noah wrote:
> > > 2007/9/5, Martin K. Petersen <martin.petersen@oracle.com>:
> > > > >>>>> "Jan" == Jan Engelhardt <jengelh@computergmbh.de> writes:
> > > >
> > > > Jan> 11:40 sun:../scsi_host/host0 # echo 1 >scan
> > > > Jan> -bash: echo: write error: Invalid argument
> > > >
> > > > Jan> What is the proper way to trigger a rescan, if it comes to be
> > > > Jan> necessary?
> > > >
> > > > echo "- - -" > scan
> >           ^^^^^
> > > >
> > > # echo --- > /sys/class/scsi_host/host9/scan
> >          ^^^
> > > -bash: echo: write error: Invalid argument
> >
> > Note the spaces between the dashes.
> 
> Thanks. Unfortunately it produced the same error.
> Is rescanning even supported with the sata_nv driver?

Works just fine here:
root@atjola:/sys/class/scsi_host/host0# echo - - - > scan 
root@atjola:/sys/class/scsi_host/host0# cat proc_name 
sata_nv

Björn
