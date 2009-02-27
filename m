Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbZB0Aac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbZB0Aac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZB0AaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:30:14 -0500
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:38201 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752846AbZB0AaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:30:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=aBfCqQGFwF6x8e3u+5U4Duie1uGH6B12611b9zjbgGjaryv2Cd7Sf4Z1smCN71cYH5pMzbb4WhG4DVpFnCj+XALe5L5zGtXZUmIsQ8xGOfeoz0qByr5ooEvfpEM8pFIN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] PCI: AMD 813x B2 devices do not need quirk
Date: Thu, 26 Feb 2009 16:29:54 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Stefan Assmann <sassmann@novell.com>,
       Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, stable@kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090226184648.GA5564@kroah.com>
In-Reply-To: <20090226184648.GA5564@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261629.55287.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 26, 2009 10:46:48 am Greg KH wrote:
> From: Stefan Assmann <sassmann@novell.com>
>
> Turns out that the new AMD 813x devices do not need the
> quirk_disable_amd_813x_boot_interrupt quirk to be run on them, if it is,
> no interrupts are seen on the PCI-X adapter.

Applied to my for-linus branch and pushed to Linus.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
