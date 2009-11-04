Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZKDIHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZKDIHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZKDIHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:07:52 -0500
Received: from isilmar.linta.de ([213.133.102.198]:33622 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752639AbZKDIHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:07:51 -0500
Date: Wed, 4 Nov 2009 09:07:54 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: linux-next: pcmcia tree build failure
Message-ID: <20091104080754.GA27784@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-usb@vger.kernel.org
References: <20091104131540.f39af556.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104131540.f39af556.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Nov 04, 2009 at 01:15:40PM +1100, Stephen Rothwell wrote:
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/telephony/ixj_pcmcia.c: In function 'ixj_probe':
> drivers/telephony/ixj_pcmcia.c:35: error: 'link' undeclared (first use in this function)
> 
> Caused by commit 990c0c8eeb34f62d062052d462feaa99715cb043 ("pcmcia: use
> dynamic debug infrastructure, deprecate CS_CHECK (misc drivers)").
> 
> I have used the version of the pcmcia tree from next-20091102 for today.
> Please build test.  :-(

Thanks -- fixed both issues (build failure and test setup).

Best,
	Domiik
