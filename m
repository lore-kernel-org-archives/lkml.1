Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbZF1WrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbZF1WrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZF1Wq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:46:57 -0400
Received: from tundra.namei.org ([65.99.196.166]:33355 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZF1Wq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:46:57 -0400
Date: Mon, 29 Jun 2009 08:46:07 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Chris Wright <chrisw@sous-sol.org>,
       Joseph Cihula <joseph.cihula@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v4][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
 support
In-Reply-To: <20090626213045.GA22359@elf.ucw.cz>
Message-ID: <alpine.LRH.2.00.0906290828200.29509@tundra.namei.org>
References: <4A299051.40405@intel.com> <alpine.LRH.2.00.0906121509001.14633@tundra.namei.org> <20090619150514.GE1389@ucw.cz> <20090619183414.GG19771@sequoia.sous-sol.org> <alpine.LRH.2.00.0906221135550.18633@tundra.namei.org>
 <20090626213045.GA22359@elf.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Pavel Machek wrote:

> 
> > Also, hardware security measures such as TXT are important in providing 
> > stronger mechanisms to ensure that kernel security mechanisms are 
> > functioning correctly.
> 
> I don't get it. How does TXT help kernel security mechanisms?

Kernel security mechanisms can be subverted and bypassed in the case of an 
exploitable kernel vulnerability, or from exploitable buggy hardware (e.g. 
which can access the entire host's memory via DMA).  Attacks on kernel 
security mechanisms have been describe in detail, see: 
http://www.phrack.com/issues.html?issue=66&id=15#article

This is close to impossible to solve from within the kernel alone. 
Hardware support is required to allow protection of the IO space (e.g. via 
IOMMU/VT-d), and to allow verification of the kernel itself (via TXT).

A significant advance in this area is LKIM:
"Linux kernel integrity measurement using contextual inspection"
http://portal.acm.org/citation.cfm?id=1314354.1314362

(Unfortunately, the ACM has not made this freely available, although I 
understand that individual authors are allowed to distribute their own 
papers as they see fit).


- James
-- 
James Morris
<jmorris@namei.org>
