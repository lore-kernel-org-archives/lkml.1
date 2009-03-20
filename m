Return-Path: <linux-kernel-owner+w=401wt.eu-S1760506AbZCTSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760506AbZCTSle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbZCTSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:41:13 -0400
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:52512 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760187AbZCTSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:41:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=S5n4CYrSFRSR1fmJ3BvYr2196bJELBN6xiyj0Z5EBWmmjK6W5f6DdV/08qdqFFIk6rQf5qYwmpIltSI0PDohWSIKOBc3MlScAwS0sz6YjXOcJGWRpcOswpE7xQYjA3fA;
Date: Fri, 20 Mar 2009 11:41:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci: Detect mmconfig on nVidia MCP55 -v2 - resend
Message-ID: <20090320114107.2bfc9356@hobbes.lan>
In-Reply-To: <49C31444.1000700@kernel.org>
References: <20090205181505.GB5661@elte.hu>
	<20090319193218.445ce0ca@hobbes.lan>
	<49C31444.1000700@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 20:57:56 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> From: Ed Swierk <eswierk@aristanetworks.com>
> 
> Subject: [PATCH] x86/pci: Detect mmconfig on nVidia MCP55 -v2
> 
> Detect and enable memory-mapped PCI configuration space on the nVidia
> MCP55 southbridge.  Tested against 2.6.27.4 on an Arista Networks
> development board with one MCP55, Coreboot firmware, no ACPI.
> 
> v2: add multi mcp55 support, and conexist with amd quad core system
> by Yinghai also only enable it only when acpi=off or acpi is not
> built-in
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
