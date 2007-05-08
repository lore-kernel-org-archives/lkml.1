Return-Path: <linux-kernel-owner+w=401wt.eu-S934596AbXEHJq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596AbXEHJq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966395AbXEHJqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:46:25 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4765 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966403AbXEHJqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:46:24 -0400
Message-ID: <464046EC.40301@shadowen.org>
Date: Tue, 08 May 2007 10:46:20 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.21-mm1 -- x86 verify_cpu.S compile failure
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are seeing the following compile error on older x86 installs:

  arch/i386/kernel/verify_cpu.S: Assembler messages:
  arch/i386/kernel/verify_cpu.S:13: Error: `(%esp)' is
			 not a valid 16 bit base/index expression

Seems to come from:

  x86_64-mm-i386-verify-cpu

Compiler:

  gcc version 3.3.4 (Debian 1:3.3.4-3)

-apw
