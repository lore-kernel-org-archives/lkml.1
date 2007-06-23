Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXFWAin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXFWAin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 20:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXFWAif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 20:38:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbXFWAie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 20:38:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Yinghai.Lu@sun.com
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Date: Sat, 23 Jun 2007 02:38:20 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706221219.16243.yinghai.lu@sun.com> <200706230214.02535.ak@suse.de> <467C6906.6020105@sun.com>
In-Reply-To: <467C6906.6020105@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706230238.20929.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> current I only test kexec only. So clean shut GART in first kernel will help.
> 
> where is hook for shutdown? add one in dma_ops?

The low level code could just register its own shutdown handler.
No need to go through dma_ops I think.

-Andi
