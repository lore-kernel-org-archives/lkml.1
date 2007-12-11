Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXLKS12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXLKS12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXLKS1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:27:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38012 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbXLKS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:27:18 -0500
Subject: Re: [kvm-devel] [RFC] Proposed new directory layout for kvm and
	virtualization
From: Hollis Blanchard <hollisb@us.ibm.com>
Reply-To: Hollis Blanchard <hollisb@us.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <475ECC04.8000609@qumranet.com>
References: <475E5CBB.9080608@qumranet.com>
	 <20071211161032.GA25769@uranus.ravnborg.org>
	 <475EB7AC.9040903@qumranet.com>
	 <20071211173717.GA26368@uranus.ravnborg.org>
	 <475ECC04.8000609@qumranet.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 11 Dec 2007 12:26:32 -0600
Message-Id: <1197397592.9632.26.camel@basalt>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 19:42 +0200, Avi Kivity wrote:
> 
> > Are there any dependencies between the arch and non-arch files
> > such as they are combined in a single module?  
> 
> Yes, they are combined into a single module.
> 
> In the case of x86, some of arch/x86/... will be combined with
> virt/kvm/ to form kvm.ko, while others will generate kvm-intel.ko and
> kvm-amd.ko.

Also, asm-offsets is a major sticking point. Either we create a
dependency on arch/*/kernel/asm-offsets.c, or we find a way to create a
new arch/*/virt/asm-offsets.c file.

-- 
Hollis Blanchard
IBM Linux Technology Center

