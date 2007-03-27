Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbXC0Dbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbXC0Dbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbXC0Dbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:31:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16804 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbXC0Dbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:31:32 -0400
X-IronPort-AV: i="4.14,331,1170651600"; 
   d="scan'208"; a="25571014:sNHT25893469"
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
	bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI>
	 <20070326024143.a226c9b2.akpm@linux-foundation.org>
	 <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com>
	 <6791.1174909459@redhat.com> <11045.1174911764@redhat.com>
	 <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI>
	 <22674.1174915478@redhat.com>
	 <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 27 Mar 2007 11:29:34 +0800
Message-Id: <1174966174.6966.5.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 16:21 -0400, Mike Frysinger wrote:
> On 3/26/07, David Howells <dhowells@redhat.com> wrote:
> > [*] The FRV, for example, does have some limited protection capability - but
> > it is really limited and not really useful in this case.
> 

Sorry for late response.

> how so ?  the Blackfin processor lacks a MMU but it does have a MPU
> (memory protection unit) which allows granularity down to 1k page
> sizes ... so for future releases, we plan on integrating optional
> support for this so that you could have processes protected from each
> other and the kernel protected from all the processes ... so in our
> case, we might actually be able to support revoking of maps because we
> would have that region of memory ear marked as unaccessible ...
> 

Agree. MPU of Blackfin can provide some processes protection. But maybe
at this moment just disable revoke for NOMMU is easier for further
development. When we provide the MPU stuff, maybe we can enable the
revoke for NOMMU but MPU arch.

> note that the Blackfin processor manuals confusingly call this aspect
> of the chip an "MMU" ... dont be fooled !
> -mike

Thanks
-Bryan
