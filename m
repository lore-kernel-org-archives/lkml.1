Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZFYWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZFYWqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZFYWqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:46:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:11857 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZFYWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jBnNaFuJZqwXGbMvMQiwIO7RsqFkc/qS40KgW1qwi9qBuPIautGMxVk/+/yN2WJge7
         VZMlO4BmTL93iV5qIhlMDcq2iB8dgCFZsUuO++YPDfBcloq+znxFOWCvsz+UjtWDoQjL
         D1EIXRcT/e4H+X2eZFVvjVDJy3midRF8v/oBs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906251459320.3605@localhost.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	 <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	 <20090625041605.GA9330@linux-os.sc.intel.com>
	 <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
	 <1245913886.17089.91.camel@macbook.infradead.org>
	 <1245966743.30355.42.camel@macbook.infradead.org>
	 <alpine.LFD.2.01.0906251459320.3605@localhost.localdomain>
Date: Thu, 25 Jun 2009 15:46:35 -0700
X-Google-Sender-Auth: 975398aa56edf097
Message-ID: <12c511ca0906251546u149e28a0s39f77e2b480f60ee@mail.gmail.com>
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity 
	Mapping Support
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 3:00 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
>> Does this work everywhere... ?
>
> Whimper.
>
> Please pleas please please.. Pretty please, let this work (instead of
> duplicating the insanity).

Well it compiles on all the ia64 configurations (with and without
iommu configured).  So that is a big step forward.  It boots on
a machine w/o an iommu.  Fenghua will have to test on his machine
that has an iommu to confirm that this works for ia64.

-Tony
