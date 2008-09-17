Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYIQXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYIQXDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYIQXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:03:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:31835 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYIQXDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qKsAF9NoLq/wNewCHUTefdQSAgsEalMQZVas5wUn+FqMnv6F+APXoKwFApkSCBhJ7V
         do05P2YHNTvg2Gc/OFwkTRoc4kxgL72oEjw7Ny5qv7mqaBlVKg3zB+Ger8YXehRlHdcj
         xnZ9EAwnFtrSW2i7QEsf9OTC4tV7DB3ugJgJU=
Message-ID: <86802c440809171603s2255f922vef0ec763cb26d535@mail.gmail.com>
Date: Wed, 17 Sep 2008 16:03:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 3/6] pci: using printk(KERN_PCI v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200809171628.05689.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221640067-24389-4-git-send-email-yhlu.kernel@gmail.com>
	 <200809171628.05689.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 3:28 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Wednesday 17 September 2008 02:27:44 am Yinghai Lu wrote:
>> v2: use printk(KERN_DEBUG KERN_PCI ...
>> v3: fix checkpatch error and warning
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  drivers/pci/probe.c |   28 +++++++++++++++++-----------
>>  1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> Index: linux-2.6/drivers/pci/probe.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/probe.c
>> +++ linux-2.6/drivers/pci/probe.c
>> @@ -304,7 +304,8 @@ static int __pci_read_base(struct pci_de
>>               } else {
>>                       res->start = l64;
>>                       res->end = l64 + sz64;
>> -                     printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>> +                     printk(KERN_DEBUG KERN_PCI
>> +                              "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>>                                pci_name(dev), pos, res->start, res->end);
>
> I really don't understand the point of this series.  I think
> the user experience is too confusing.
>
> But if you're going to change printks like the one above,
> please at least make it use dev_printk() like most of the
> rest of the PCI core.

will look at dev_printk...

YH
