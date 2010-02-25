Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab0BYUcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:32:13 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33433 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933351Ab0BYUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:32:11 -0500
Subject: Re: VMI and kmap_atomic_pte paravirt_op
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1267127532.2488.7.camel@localhost.localdomain>
References: <1267127532.2488.7.camel@localhost.localdomain>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 25 Feb 2010 12:32:10 -0800
Message-Id: <1267129930.10104.4.camel@ank32>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian, 

On Thu, 2010-02-25 at 11:52 -0800, Ian Campbell wrote:
> Hi Alok,
> 
> How critical is the vmi_kmap_atomic_pte pv_mmu_op hook to VMI? Is it
> required for correct functionality or is it simply an optimisation?
> 
> We think we may be able to do away with the Xen version of the hook and
> if VMI (which is deprecated) can live without it and you agree then I'll
> cook up a patch to remove it altogether.

As Jeremy suggests we will be fine with disabling high ptes for VMI. 
Thanks for doing this. 

Alok
> 
> Thanks,
> Ian.
> 
> 

