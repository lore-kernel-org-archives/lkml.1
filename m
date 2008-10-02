Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYJBSqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYJBSqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYJBSqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:46:34 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:60658 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753188AbYJBSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:46:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DS8MibEttCvq5EB8O/Si8Pxt55KmkOA8WK3NIWlKqPqh/DOQlmRQBVxhYdH/G7sjATCk8EYAWdh4Cs54lATH1vHv9Nv0abQOjrR/FhxrGhUOw8beqXsmmSwPu1rVoJCZ;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Vincent Legoll" <vincent.legoll@gmail.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Date: Thu, 2 Oct 2008 11:46:28 -0700
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com>
In-Reply-To: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021146.28704.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 29, 2008 2:03 pm Vincent Legoll wrote:
> Hello,
>
> Here is a patch to uniformize PCI probing debug messages at
> boot with dev_printk() intead of manual printk()
>
> for example, it goes from the mixed-style:
>
> PCI: 0000:00:1b.0 reg 10 64bit mmio: [f4280000, f4283fff]
> pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>
> to uniform:
>
> pci 0000:00:1b.0: reg 10 64bit mmio: [f4280000, f4283fff]
> pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>
> If people prefer the UPPERCASE "PCI:" prefix from dev_printk(),
> that would be matter for another patch...
>
> I'm currently running the kernel with that patch applied, and
> diffed bootlog, everything looks OK
>
> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>

Bjorn, how does this jive with the various other debug harmonization patches 
you've been putting together & reviewing?

Thanks,
Jesse

-- 
Jesse Barnes, Intel Open Source Technology Center
