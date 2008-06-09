Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYFIKBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYFIKBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbYFIKBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:01:44 -0400
Received: from hpsmtp-eml19.kpnxchange.com ([213.75.38.84]:16335 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758570AbYFIKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:01:44 -0400
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: Linux 2.6.26-rc5
Date: Mon, 9 Jun 2008 12:01:40 +0200
User-Agent: KMail/1.9.9
Cc: Jesper Krogh <jesper@krogh.cc>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Avuton Olrich <avuton@gmail.com>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <200806072350.59976.elendil@planet.nl> <200806082139.45829.bjorn.helgaas@hp.com>
In-Reply-To: <200806082139.45829.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091201.41167.elendil@planet.nl>
X-OriginalArrivalTime: 09 Jun 2008 10:01:42.0146 (UTC) FILETIME=[D11D0E20:01C8CA17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Bjorn Helgaas wrote:
> On Saturday 07 June 2008 3:50:59 pm Frans Pop wrote:
> > Jesper Krogh wrote:
> > > Not that they seem critical to the system but I do get alot of
> > > these. I cant remember having seen that before.
> > >
> > > [    2.904467] system 00:06: iomem range 0x0-0x0 could not be reserved 
> > > [    2.904469] system 00:06: iomem range 0x0-0x0 could not be reserved 
> > > [    2.904471] system 00:06: iomem range 0x0-0x0 could not be reserved 
> > > [    2.904473] system 00:06: iomem range 0x0-0x0 could not be reserved
> >
> > I'm getting these too. Not present in the last -rc4 kernel I built.
>
> The patch below should fix this and is already in Linus' tree.
> Can you give it a whirl to confirm?  Thanks!
>
> PNP: skip UNSET MEM resources as well as DISABLED ones
[...]

Yes, that does the trick. Tested using a kernel built from git head.

Thanks,
FJP
