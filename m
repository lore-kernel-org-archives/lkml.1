Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbXH3VQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbXH3VQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXH3VQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:16:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:55345 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXH3VQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NbkrvAZX4g8Gzr+o2tujBy6ZqnhsHRlpr2pwpU1/0bRfdkibDoUsWVbfksoEOigkvq953iMZ8XTzytaqYb7ykTsMdkzVt9io/mQdoIQhxhVYmX9g27O2e6wl1w51JdBQT9o53+4EJJscI4J4DdhcdZKtrcXJ++BZJkCsk51+dvQ=
Message-ID: <87f94c370708301416j2a7c000bscbaef593af004010@mail.gmail.com>
Date: Thu, 30 Aug 2007 17:16:46 -0400
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: Problems with IDE on linux 2.6.22.X
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "=?ISO-8859-1?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?=" <jopan@alumni.uv.es>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org
In-Reply-To: <46D7231B.3080807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708212149.12912.jopan@alumni.uv.es>
	 <20070822162312.GG9412@csclub.uwaterloo.ca>
	 <46CC6A2F.5000406@gmail.com> <200708280044.34475.jopan@alumni.uv.es>
	 <46D455DB.8000800@gmail.com>
	 <Pine.LNX.4.64.0708302130210.24730@fbirervta.pbzchgretzou.qr>
	 <46D7231B.3080807@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 08/30/2007 09:31 PM, Jan Engelhardt wrote:
>
> > On Aug 28 2007 19:05, Rene Herman wrote:
>
> >> Sheesh. How could anyone _not_ understand you need SCSI CD-ROM support
> >> for your IDE DVD-RW drive...
> >
> > Welcome to the wonderful world of SCSIfying ATA. (Don't talk about ATAPI,
> > USB/Firewire, it's a different matter.)
>
> Well -- the world where ATA, SCSI, USB, Firewire and what have you are
> low-level drivers to a unifying storage layer is under non too obscure
> definitions sort of not non-wonderful...
>

USB / Firewire / FC / iSCSI are all SCSI transports and fit within the
SCSI subsystem by design.

ie. Just like ethernet, DSL, T-1, etc can all carry IP traffic with no
conceptual conflict, many media by design carry SCSI traffic.

The PATA and SATA physical layer typically carry ATA commands and
having them tied into the SCSI stack is an aberration that I hope will
be eliminated some day.

ATAPI is an exception.  Not sure where that would end up in a perfect world.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
