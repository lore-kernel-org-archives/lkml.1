Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZJNAjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZJNAjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZJNAjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:39:44 -0400
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:56380 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751766AbZJNAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:39:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=odQ48zCAU9Q7/YzshPIwxX5/ZJuapFUnGjWVyEAirwViOYPQ1LvxXpCMRsxvfujs4cZtCYrJd6+h6h2l9ijjTXdkltrxwDz7GKtI3FvUK1+IiqtWzkhIWNRF1P73+TT3;
Date: Tue, 13 Oct 2009 17:38:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
Message-ID: <20091013173842.3c926b0c@jbarnes-g45>
In-Reply-To: <20091014110532.f543b915.sfr@canb.auug.org.au>
References: <20091014110532.f543b915.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 11:05:32 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next merge of the pci tree got a conflict in
> drivers/pci/pci.c between commit
> 8d86fb2c80ec376b35ae64ac858d406ae1d42a3f ("Rename pci_init() to
> pci_apply_final_quirks(), move it to quirks.c") from Linus' tree and
> commit b20dd110d21aac94b3f4063cffbcf9718656ce51 ("PCI: determine CLS
> more intelligently") from the pci tree.
> 
> I fixed it up by removing the bits of pci_init() that had been moved
> and leaving the newly added bits where they are.  Hopefully this will
> be ok since the moved bits are actually run earlier now.  Obviously,
> there is probably a better fix ...

Ah, thanks.  I'll check it out and update my linux-next branch.

-- 
Jesse Barnes, Intel Open Source Technology Center
