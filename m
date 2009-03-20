Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbZCTRy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbZCTRy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 13:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZCTRyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 13:54:19 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:41102 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755214AbZCTRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:54:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ReklxK5jBo+8wWhZJbbxJv1/vaTwT2jmqoEWPMKcOA83XQcxAwD1N9nOB/L8/BZVoVY5ULeZfTd0UEMBX2uknqFItvYMjHSBEh+HSoDLHdANdblieSaQLS3ipLMXL9sh;
Date: Fri, 20 Mar 2009 10:54:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH v12 1/8] PCI: initialize and release SR-IOV capability
Message-ID: <20090320105409.5ed80885@hobbes.lan>
In-Reply-To: <1237519518-24048-2-git-send-email-yu.zhao@intel.com>
References: <1237519518-24048-1-git-send-email-yu.zhao@intel.com>
	<1237519518-24048-2-git-send-email-yu.zhao@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 11:25:11 +0800
Yu Zhao <yu.zhao@intel.com> wrote:

> If a device has the SR-IOV capability, initialize it (set the ARI
> Capable Hierarchy in the lowest numbered PF if necessary; calculate
> the System Page Size for the VF MMIO, probe the VF Offset, Stride
> and BARs). A lock for the VF bus allocation is also initialized if
> a PF is the lowest numbered PF.
> 
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

I applied this series to my linux-next branch, but there were a few
conflicts here and there, so please check it out.  Looks like from
start to finish this took about 6 months to get banged into shape,
thanks for staying on it, Yu!

-- 
Jesse Barnes, Intel Open Source Technology Center
