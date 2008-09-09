Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYIISk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYIISk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYIISks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:40:48 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:51920 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753782AbYIISkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:40:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=lA134SgyJxN9eOrQfTLrT4Ad38wB8DrLcdab8IbnDDhqFzi1QJKe7423Hs94PW7OkSIgA67UD0+XOtG48/j/97PFqOa6iw4cgCmBWHsNFSm7JTqqRn68AXQHSI83QmAV;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] fix pciehp_free_irq()
Date: Tue, 9 Sep 2008 11:40:41 -0700
User-Agent: KMail/1.9.9
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20080827220526.GR11734@cs181140183.pp.htv.fi>
In-Reply-To: <20080827220526.GR11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091140.41791.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2008 3:05 pm Adrian Bunk wrote:
> This patch fixes an obvious bug (loop was never entered) caused by
> commit 820943b6fc4781621dee52ba026106758a727dd3
> (pciehp: cleanup pcie_poll_cmd).
>
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to my linux-next branch.  Kenji-san do you think this should go into 
2.6.27?  I haven't heard any regression reports about it, but it does seem 
like a good and simple fix...

Thanks,
Jesse
