Return-Path: <linux-kernel-owner+w=401wt.eu-S1752416AbYKRJhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbYKRJhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYKRJhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:37:23 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:60327 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYKRJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:37:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x5JwxFV8I5zvloKpWuVlI4zJirVbeZfNFO5rYaXxhC/0BES5uIFoU7zMkhuL+5+CDm
         vtn6hFbNYG8EqAngIngteuK4KDtSdZJE3l4fDwnnm47L4NlEp714/8eGmHAXnc2Bb0RF
         3bXN63Ej7zS8yTJAebBlhyeTH01nCQr2xrMRM=
Message-ID: <c384c5ea0811180137l2f82147eqb0af68baac9ed4b2@mail.gmail.com>
Date: Tue, 18 Nov 2008 10:37:21 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Tejun Heo" <tj@kernel.org>
In-Reply-To: <1226985689.3403.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c384c5ea0811171354u5d6f5be6v857f92b1e75769c7@mail.gmail.com>
	 <20081117191532.c1c849f5.akpm@linux-foundation.org>
	 <1226985689.3403.20.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Tue, Nov 18, 2008 at 6:21 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2008-11-17 at 19:15 -0800, Andrew Morton wrote:
>> (cc's added)
>>
>> On Mon, 17 Nov 2008 22:54:33 +0100 "Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:
>> > pci_map_sg() does not coalesce the scattergather list for me on x86.
>> In which kernel version(s)?
>
2.6.24 for x86, and 2.6.27 for powerpc. Sorry, this is a bogus report:

I tried to isolate the scattergather implementation, thereby the dev
pointer got NULL, which results in different dma_ops.

I am bringing a freshly written driver upstream 'altpciechdma' for the
Altera FPGA PCI Express Chaining DMA reference design. Will probably
appear in staging RSN.

Thanks for the help,
-- 
Leon
