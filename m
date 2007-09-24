Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXIXUz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXIXUz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXIXUzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:55:14 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:52988 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbXIXUzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:55:13 -0400
Date: Mon, 24 Sep 2007 13:55:06 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: linux-kernel@vger.kernel.org
Cc: Stephane Eranian <eranian@hpl.hp.com>, perfmon@napali.hpl.hp.com
Subject: /proc/kallsyms and symbol size
Message-ID: <20070924205506.GC31899@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Many monitoring tools use /proc/kallsyms to build a symbol table for the kernel.
This technique has the advantage that it does not require root privileges, nor
an up-to-date /boot/System.map, nor a decompressed kernel in /boot.

The problem is that /proc/kallsyms does not report the size of the symbols.
Yet, the information is available in the kernel as it is used by functions such
as __print_symbol(). Having the size is useful to correlate the address obtained
is a sample with a symbol name. Most tools use an approximation which assumes
symbols are contiguous to estimate the size.

Apart from the backward compatbility problem for the output of kallsyms, what
would be the major issue with exposing this information?

Thanks.

-- 
-Stephane
