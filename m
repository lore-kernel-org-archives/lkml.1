Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbZKXX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbZKXX0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934414AbZKXX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:26:38 -0500
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:51814 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934408AbZKXX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:26:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TnrzHq6JRIE6rSqH5IlylvntXls+h2jis/Bp3C6vhFF6EIwRxaivBJSx+6eQxNck0sqERjtzH2LCAI6sbJKd9oO4EQz7C1Ie9Lk+4AkuSajPYGSrFtdJIcpQgSVv5lPp;
Date: Tue, 24 Nov 2009 15:26:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: seperate x86_pci_rootbus_res_quirks from
 amd_bus.c
Message-ID: <20091124152641.0491e2fe@jbarnes-piketon>
In-Reply-To: <4AFBAADC.4070801@kernel.org>
References: <4AFBAADC.4070801@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 22:27:40 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> those functions are used by intel_bus.c
> 
> so seperate them to another file. and make amd_bus some smaller.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
