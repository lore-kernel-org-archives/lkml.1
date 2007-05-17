Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbXEQRFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbXEQRFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXEQRFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:05:40 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbXEQRFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:05:39 -0400
Message-ID: <464C8B60.5040109@zytor.com>
Date: Thu, 17 May 2007 10:05:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 new setup: use appropriate sections for code and
 data
References: <20070517112553.GA12901@mailshack.com>
In-Reply-To: <20070517112553.GA12901@mailshack.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> An intermediate elf file is generated for the 16-bit setup code.
> The generated code can be viewed using objdump -m i8086 -d. As it
> stands, it also tries to disassemble the bugger_off_msg, which
> results in garbage. This introduces two new sections to separate
> the code and the data part of the bootsector stub. It also moves
> some code from the .header section (a data section) to .inittext.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>
> ---
> 
> Hi,
> 
> I hope the new section names are ok? Alternatives would be
> .bstext/.bsdata or .floppytext/.floppydata.

I'd prefer .bstext or .bs_text and .bsdata/.bs_data; possibly .bsecttext
and .bsectdata.  The term "boot sector" for that particular piece of
code is firmly established.

	-hpa


