Return-Path: <linux-kernel-owner+w=401wt.eu-S1750848AbXCZUVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848AbXCZUVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXCZUVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:21:53 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:16748 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXCZUVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=usRAqcfq90Zj0YgL74UThnEBH0RHbtAYEAj9NBquEXTkARpUVwYv/t4ZIkBWWAvcz6eMI1Gq9dPIOeHEcRfGFm/EuGP/cK282K8A1oJokS1321kU5vhbkQGo7/ZYFrE/HgWOrdSekqitpX3m2RQJGLUIVwV8y3WXSOOtoEXc6hY=
Message-ID: <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>
Date: Mon, 26 Mar 2007 16:21:51 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <22674.1174915478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI>
	 <20070326024143.a226c9b2.akpm@linux-foundation.org>
	 <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com>
	 <6791.1174909459@redhat.com> <11045.1174911764@redhat.com>
	 <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI>
	 <22674.1174915478@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, David Howells <dhowells@redhat.com> wrote:
> [*] The FRV, for example, does have some limited protection capability - but
> it is really limited and not really useful in this case.

how so ?  the Blackfin processor lacks a MMU but it does have a MPU
(memory protection unit) which allows granularity down to 1k page
sizes ... so for future releases, we plan on integrating optional
support for this so that you could have processes protected from each
other and the kernel protected from all the processes ... so in our
case, we might actually be able to support revoking of maps because we
would have that region of memory ear marked as unaccessible ...

note that the Blackfin processor manuals confusingly call this aspect
of the chip an "MMU" ... dont be fooled !
-mike
