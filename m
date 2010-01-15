Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab0AOSIa (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886Ab0AOSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:08:29 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:55470 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757779Ab0AOSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:08:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mf5vo+wfuZN0UXznXk5OGoiC1Yrd6X2NXEulO7Nd28hF0NnOoPllUASxLh/7PJJUMCEYDJe2TjcnLuaK5oCN2uxS9iVKZZztlvjHAxK8G5MTAc0EqrNCc+Az0YW3o0+G;
Date: Fri, 15 Jan 2010 10:08:30 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Miller <davem@davemloft.net>, Greg KH <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH/REPOST] pci: push deprecated pci_find_device() function
 to last user
Message-ID: <20100115100830.152bd145@jbarnes-piketon>
In-Reply-To: <20100114221841.D282640108@xenon.ts.pxnet.com>
References: <20100113142328.5DE2F40107@xenon.ts.pxnet.com>
	<20100113.203338.52448956.davem@davemloft.net>
	<20100114044331.GA29008@suse.de>
	<20100114.001204.203918209.davem@davemloft.net>
	<20100114082823.63379b3d@jbarnes-piketon>
	<20100114221841.D282640108@xenon.ts.pxnet.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 23:18:41 +0100 (CET)
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 14.01.2010 17:28 schrieb Jesse Barnes:
> > I can take it, but I lost the original patch.  Tilman, can you
> > resend?
> 
> Sure, here you are:
> 
> Subject: [PATCH] pci: push deprecated pci_find_device() function to
> last user
> 
> The ISDN4Linux HiSax driver family contains the last remaining users
> of the deprecated pci_find_device() function. This patch creates a
> private copy of that function in HiSax, and removes the now unused
> global function together with its controlling configuration option,
> CONFIG_PCI_LEGACY.
> 
> Impact: code reorganization, no functional change
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> ---
> Note: This patch is not, nor does it intend to be, checkpatch.pl
> clean. The issues checkpatch.pl reports on it were already present
> before, and are unrelated to the topic of this patch.

Applied to my linux-next branch, thanks Tilman.

-- 
Jesse Barnes, Intel Open Source Technology Center
