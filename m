Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZHJQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZHJQ6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932287AbZHJQ6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:58:38 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:32807 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932282AbZHJQ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:58:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IL4w+DRbJmGVQnnZG/BrySSvFyXyGoGaA272f17D3+p5Fmz0e3yc1LAjqY84ErwMZVhgFOdFOaLEBGZlCKXK/qC1PFUExIxCyc7326fcsfITmaTcPZU2+RaP227hvx8X;
Date: Mon, 10 Aug 2009 09:58:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: [patch 2/2] x86: arch specific support for remapping HPET MSIs
Message-ID: <20090810095836.1f86433b@jbarnes-g45>
In-Reply-To: <20090808151254.GC28892@elte.hu>
References: <20090804190729.477649000@intel.com>
	<20090804190729.630510000@intel.com>
	<20090808151254.GC28892@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009 17:12:54 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > x86 arch support for remapping HPET MSI's by associating the HPET 
> > timer block with the interrupt-remapping HW unit and setting up 
> > appropriate irq_chip
> 
> interesting. This means we'd materially utilize the irq-remapper not 
> just on relatively obscure, virtualization related setups, but also 
> in the native x86 bootup mode, on all (hpet+remap capable) Linux 
> systems?
> 
> I like it - but i'll defer to Thomas to queue it up.

I guess this set should go through either the iommu or -tip tree.

-- 
Jesse Barnes, Intel Open Source Technology Center
