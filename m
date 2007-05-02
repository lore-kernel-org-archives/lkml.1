Return-Path: <linux-kernel-owner+w=401wt.eu-S2993398AbXEBPnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993398AbXEBPnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993399AbXEBPnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:43:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:6080 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993398AbXEBPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OuNQrLiC53XAcTfJuB6MKOuKNmF5cueWJ0dZsN5S4Jb0lhaVBCSPMzAhP/60ARgpUvdNcJZ6JXh3qLySWVSbN4Xrg6WbPxqu+FoNPFsMYg/x2rnLdxKJ55Yi9uoM+jh//7tBZFujCES6j1tKMhWZUa+apo/FE5rn1wuKLdxHclU=
Message-ID: <6278d2220705020843l718b3272k5d6ebf8b827d0806@mail.gmail.com>
Date: Wed, 2 May 2007 16:43:44 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Rajib Majumder" <rajibm2005@gmail.com>
Subject: Re: Kernel Scalability
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May, 14:00, "Rajib Majumder" <rajibm2005@gmail.com> wrote:
> Hi,
>
> I am wondering if 2.4.x/2.6.x kernel is scalable enough to run on
> 8-CPU hardware. Do we have any scalability comparison data between
> 2.4/2.6 kernels and beyond 4-CPU?
>
> If yes, is the scalablity is near linear?
>
> Any input is appreciated.

There are 128-processor IA64 systems which run recent 2.6 kernels out
there; the per-processor counters, RCU and page-fault scalability work
has been instrumental to the necessary scaling for decent resource
usage on these.

IIRC, there were some patches being developed to improve pagecache
scalability lately too, but I guess it all depends on what kind of
workload you have...

> Thanks
>
> Rajib
-- 
Daniel J Blueman
