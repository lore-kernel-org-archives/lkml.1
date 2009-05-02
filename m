Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZEBHDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZEBHDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZEBHC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:02:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:23580 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZEBHC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gj4ccfC2xXOVW+oBnKM9uGB2sIFrLruJP3Y5H0KM+twrsurpZ32UcrAAJEJ2dTwbOn
         ou4R2kkePOp72Uvajqp7vQSiRi02wiEU5t7y1fShoaHXk4K9GnjfunT38M2B0Or79xmN
         jrqueXjmKDzi8WGcXetVKhe04KVU+2wxBrT7s=
Date: Sat, 2 May 2009 11:02:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ed Swierk <eswierk@aristanetworks.com>
Subject: Re: [PATCH] x86: read apic id if it is not acpi_lapic
Message-ID: <20090502070254.GA4791@lenovo>
References: <20090430084145.GD21699@elte.hu> <49FBD0A2.4030309@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FBD0A2.4030309@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Fri, May 01, 2009 at 09:48:34PM -0700]
| 
| Ed found that on 32bit, boot_cpu_physical_apicid is not read right,
| when mptable is broken.
| 
| interesting, actually three path
| 1. acpi: at that time, at that time that is already read from reg.
| 2. mptable: that only read from mptable.
| 3. no madt, and no mptable, that use default apic id 0 for 64bit, -1 for 32bit
| 
| so could read that apic id for 2/3 path.
| 
| also could avoid set fixmap that lapic two times when acpi_lapic is used.
| and need to move cpu_has_apic earlier and call apic_disable()
| 
| Reported-by: Ed Swierk <eswierk@aristanetworks.com>
| Signed-off-by: Yinghai Lu <yinghai@kernel.org>
| Cc: Cyrill Gorcunov <gorcunov@openvz.org>
| 

Thanks Yinghai! My Ack if needed.
 
	-- Cyrill
