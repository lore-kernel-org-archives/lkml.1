Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZF3CBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZF3CBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZF3CBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:01:36 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:38204 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752542AbZF3CBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:01:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GjvPXUDvnMVmDR28+XPK7IsWmW3bzPFrHV3/qwuxLjD6dHMEWQ+ZXqa+S9HpI4tMrUTTe2oYNtBR3blV1qQVFCImchCM2LjqJFCMCoCk0FOwuvfunxRelbOJmiRxWvQh;
Date: Mon, 29 Jun 2009 19:01:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>, Alex Chiang <achiang@hp.com>
Subject: Re: linux-next: manual merge of the pci tree with Linus' tree
Message-ID: <20090629190135.7ff6a089@jbarnes-g45>
In-Reply-To: <20090630115638.7bfb8e21.sfr@canb.auug.org.au>
References: <20090630115638.7bfb8e21.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 11:56:38 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next merge of the pci tree got conflicts in
> arch/ia64/include/asm/pci.h, arch/mn10300/include/asm/pci.h and
> include/asm-generic/pci.h between commit
> a6c140969b4685f9b9f6773c0760f55ca66d1825 ("Delete
> pcibios_select_root") from Linus' tree and commit
> a53cd7419b22c14b5a1e6859a940fb6bfa77963f ("PCI: remove
> pcibios_scan_all_fns()") from the pci tree.
> 
> Just context changes (adjacent removals).  I fixed it up (see below)
> and can carry the fix for a while.

Ah ok, thanks.  That'll get fixed up after I send the current for-linus
bits over and refresh my PCI tree.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
