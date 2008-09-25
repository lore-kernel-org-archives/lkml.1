Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbYIYQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbYIYQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYIYQQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:16:50 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:43210 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752710AbYIYQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:16:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OdZTAbiVquHdf0XWhoXt5UU0B9zU8ePG7OhpkcyyKYVyITxpb8OMmsXMOtjOOYtSh2RCr9V431r9yOERQWrOjzQ8CBvlQXwAbWb+tZE7140Ltl7ZmC77sb2EjVd3R7PN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [patch] pci: document the pcie_aspm kernel parameter
Date: Thu, 25 Sep 2008 09:16:47 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080924204034.6eee51ae@redhat.com>
In-Reply-To: <20080924204034.6eee51ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809250916.47769.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 24, 2008 5:40 pm Chuck Ebbert wrote:
> From: Chuck Ebbert <cebbert@redhat.com>
>
> pci: document the pcie_aspm kernel parameter
>
> Index: linux-2.6.26.noarch/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.26.noarch.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6.26.noarch/Documentation/kernel-parameters.txt
> @@ -1636,6 +1636,12 @@ and is between 256 and 4096 characters.
>  				reserved for the CardBus bridge's memory
>  				window. The default value is 64 megabytes.
>
> +	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
> +			Management.
> +		off	Disable ASPM.
> +		force	Enable ASPM even on devices that claim not to support it.
> +			WARNING: Forcing ASPM on may cause system lockups.
> +
>  	pcmv=		[HW,PCMCIA] BadgePAD 4
>
>  	pd.		[PARIDE]

Applied to linux-next, thanks Chuck.

-- 
Jesse Barnes, Intel Open Source Technology Center
