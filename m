Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZCKPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZCKPZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZCKPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:25:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58786 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZCKPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C+4l3dsrHNGtHJ7pDm/TUVfP70AtcN21ttgWdhx+VOPyzoVc2LYdSRCEXIVRp/wI9n
         41ssYoaVYkQRNyHJBhm+n2AaiQL8UxLfxkjHqy4YoSe6zW+KuVKhxJ7GnlPSLRHDkgfh
         sS+6U174PBA25KPx2yLPIAmG2Qj+W8LzhyCkI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903111606350.29264@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain>
	 <alpine.LFD.2.00.0903111606350.29264@localhost.localdomain>
Date: Thu, 12 Mar 2009 00:25:32 +0900
Message-ID: <961aa3350903110825y1af77709q49d6328703081afb@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/12 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 11 Mar 2009, Akinobu Mita wrote:
>> kmap_atomic_pfn() and iomap_atomic_prot_pfn() are almost same except
>> pgprot. This patch removes the code duplication for these two functions.
>
> How exaclty does this compile with CONFIG_HIGHMEM=n ?
>

Oh, I didn't try without CONFIG_HIGHMEM.
