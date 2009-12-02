Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZLBM4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZLBM4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZLBM4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:56:42 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:46302 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZLBM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:56:41 -0500
Date: Wed, 2 Dec 2009 14:56:49 +0300
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the pcmcia tree with the arm tree
Message-ID: <20091202115649.GA2150@rainbow>
References: <20091201140310.46dbdc59.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201140310.46dbdc59.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:03 Tue 01 Dec     , Stephen Rothwell wrote:
> Hi Dominik,
> 
> Today's linux-next merge of the pcmcia tree got a conflict in
> drivers/pcmcia/sa1100_h3600.c between commit
> 6ce8f65e71f0d80ee23b543be09789dd865a99be ("ARM: 5811/1: pcmcia: convert
> sa1100_h3600 driver to gpiolib") from the arm tree and commit
> 66024db57d5b9011e274b314affad68f370c0d6f ("PCMCIA: stop duplicating
> pci_irq in soc_pcmcia_socket") from the pcmcia tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.  Please
> check the fix below.

Fix looks good to me, and testing next-20091201 on real device (h3600)
shows no problems with pcmcia.

Perhaps this merge conflict can be avoided by merging Russell's PCMCIA
patches through arm tree. But, anyway, it's Russell and Dominik
to decide.

-- 
Best regards,
Dmitry "MAD" Artamonow

