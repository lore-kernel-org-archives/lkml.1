Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZLOSsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZLOSsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760838AbZLOSsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:48:00 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33538 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbZLOSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:47:59 -0500
Date: Tue, 15 Dec 2009 11:47:58 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
Message-ID: <20091215184758.GP7812@parisc-linux.org>
References: <20091215115052.GA28252@kernel.dk> <4B277AB2.8030107@kernel.org> <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B27D7E9.4030105@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:39:37AM -0800, Yinghai Lu wrote:
> +	/* some sys doesn't get mmconf enabled */
> +	if (dev->cfg_size < 0x200)
> +		return;

What is the meaning of this mystic 0x200?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
