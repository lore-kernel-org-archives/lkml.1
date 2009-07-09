Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZGIRad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZGIRad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZGIRa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:30:26 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:57945 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZGIRaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:30:25 -0400
Date: Thu, 9 Jul 2009 10:30:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 9 (x86/pci)
Message-Id: <20090709103021.d39a711a.randy.dunlap@oracle.com>
In-Reply-To: <20090709163031.acdb5439.sfr@canb.auug.org.au>
References: <20090709163031.acdb5439.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A562929.01C4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 16:30:31 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090708:


when ACPI is disabled (SFI=y):


arch/x86/pci/mmconfig_32.c: In function 'get_base_addr':
arch/x86/pci/mmconfig_32.c:34: error: invalid use of undefined type 'struct acpi_mcfg_allocation'
arch/x86/pci/mmconfig_32.c:34: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig_32.c:35: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig_32.c:36: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig_32.c:37: error: dereferencing pointer to incomplete type
arch/x86/pci/mmconfig_32.c:38: error: dereferencing pointer to incomplete type

(X86_32, clearly)

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
