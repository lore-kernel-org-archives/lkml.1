Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446Ab0AYHi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0AYHi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 02:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242Ab0AYHiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 02:38:55 -0500
Received: from isilmar.linta.de ([213.133.102.198]:44139 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751193Ab0AYHiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 02:38:55 -0500
Date: Mon, 25 Jan 2010 08:38:45 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: pcmcia tree build failure
Message-ID: <20100125073845.GA25453@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20100125131343.9934da5f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100125131343.9934da5f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stephen,

On Mon, Jan 25, 2010 at 01:13:43PM +1100, Stephen Rothwell wrote:
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> drivers/built-in.o:(.toc1+0xd118): undefined reference to `pcmcia_dev_list_lock'
> 
> Caused by commit fc53c3482805cb3281dbeb0bd29dd892aaa53303 ("pcmcia:
> simplify locking").
> 
> I have used the pcmcia tree from next-20100122 for today.

Thanks, fixed for tomorrow.

Best,
	Dominik
