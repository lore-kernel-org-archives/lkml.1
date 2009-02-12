Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbZBLFEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbZBLFEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 00:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZBLFEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 00:04:00 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:20614 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZBLFD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:03:59 -0500
MIME-Version: 1.0
In-Reply-To: <4990DFBA.1050401@kernel.org>
References: <1233765552.16414.6.camel@localhost.localdomain>
	 <86802c440902041212q51f2a444l84e1ac29ee6f702e@mail.gmail.com>
	 <20090204212517.GM22608@elte.hu> <498A206A.2070309@kernel.org>
	 <4990DF7C.1090701@kernel.org> <4990DFBA.1050401@kernel.org>
Date: Wed, 11 Feb 2009 21:03:57 -0800
Message-ID: <9ae48b020902112103y1af0796fmbb3bea85cc81bced@mail.gmail.com>
Subject: Re: Subject: [PATCH] x86/pci: Detect mmconfig on nVidia MCP55 -v2
From: Ed Swierk <eswierk@aristanetworks.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jbarnes@virtuousgeek.org, Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 6:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Ed Swierk <eswierk@aristanetworks.com>
>
> Detect and enable memory-mapped PCI configuration space on the nVidia
> MCP55 southbridge.  Tested against 2.6.27.4 on an Arista Networks
> development board with one MCP55, Coreboot firmware, no ACPI.
>
> v2: add multi mcp55 support, and conexist with amd quad core system by Yinghai
>    also only enable it only when acpi=off or acpi is not built-in
>
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I tested patch v2 and it works OK on our board.

--Ed
