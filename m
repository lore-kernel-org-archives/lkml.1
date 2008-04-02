Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbYDBUoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbYDBUoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765498AbYDBUfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:35:10 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:50620 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763082AbYDBUfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:35:08 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Wed, 2 Apr 2008 22:34:58 +0200
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <200804022210.26736.linux@rainbow-software.org> <20080402202225.GJ24237@csclub.uwaterloo.ca>
In-Reply-To: <20080402202225.GJ24237@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022235.01433.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008 22:22:25 Lennart Sorensen wrote:
> On Wed, Apr 02, 2008 at 10:10:23PM +0200, Ondrej Zary wrote:
> > I mean S320BIDE.EXE - that's for this machine only.
>
> Hmm, I missed that one.  I wonder how they do it.  Well ISA did support
> bus mastering DMA although it seems rare to implement it.  Or it could
> be VLB style.

I suspect that the IDE controller is integrated into the Toshiba chipset but 
does not appear as a separate PCI device. It could be controlled by some 
registers of the "host-bridge" or some other device.

-- 
Ondrej Zary
