Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753151AbYLQRiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYLQRiR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYLQRiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:38:00 -0500
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:43896 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751040AbYLQRh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:37:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Vbw0Ih/fVd8Lm4jdC/L3dnxEM3j+9TU8oES5SlUL/zHseT4FHCEatuypZgw+4HnVOJpPLi8oSzm6K1A0N+ehwkBYYlPuG6Mwo+ewgrEuFyqCSpe8c0KWOMSD+dbeDVB4;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Date: Wed, 17 Dec 2008 09:27:05 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Yu Zhao <yu.zhao@intel.com>, linux-pci@vger.kernel.org, achiang@hp.com,
        bjorn.helgaas@hp.com, grundler@parisc-linux.org, greg@kroah.com,
        mingo@elte.hu, randy.dunlap@oracle.com, rdreier@cisco.com,
        horms@verge.net.au, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <20081217141542.GB19967@parisc-linux.org>
In-Reply-To: <20081217141542.GB19967@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812170927.06532.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2008 6:15 am Matthew Wilcox wrote:
> On Tue, Dec 16, 2008 at 03:23:53PM -0800, Jesse Barnes wrote:
> > I applied 1-9 to my linux-next branch; and at least patch #10 needs a
> > respin,
>
> I still object to #2.  We should have the flexibility to have 'struct
> resource's that are not in this array in the pci_dev.  I would like to
> see the SR-IOV resources _not_ in this array (and indeed, I'd like to
> see PCI bridges keep their producer resources somewhere other than in
> this array).  I accept that there are still some problems with this, but
> patch #2 moves us further from being able to achieve this goal, not
> closer.

Yeah, I can see what you mean here...  but on the other hand it makes the 
existing code a bit clearer (no extra args), and really it doesn't push us 
*that* much further from non-pci_dev tied resources.  Any patches in that 
direction will just get a few lines bigger, that's all.

But I agree that eventually we may want to have non-pci_dev resource lists, 
especially if we start adding advanced host bridge drivers or something.

-- 
Jesse Barnes, Intel Open Source Technology Center

