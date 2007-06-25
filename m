Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbXFYAST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbXFYAST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFYASM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:18:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:16465 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXFYASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ELm8jR9EiL/MAJbClL6mb8fsWAoIJnIMDtaXynhFHG1iCk97vdP0cPHd0Hrd0ISSWNC7UYIMuflbommkwhDLy72inyodhBMmhWFJ5B/gFuBBkQh7Kxht6/sVUopxgoGWkde+6R2Q4wqPT88lU9plnRoigDHzw7dhUZ0SVdTQnGY=
Message-ID: <86802c440706241718g730a32e2hd5a0a6553f5156c6@mail.gmail.com>
Date: Sun, 24 Jun 2007 17:18:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706231308.30403.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com> <467C6906.6020105@sun.com>
	 <200706221934.59966.yinghai.lu@sun.com>
	 <200706231308.30403.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/07, Andi Kleen <ak@suse.de> wrote:

> So my suggestion would be:
>
> (1) implement sysfs platform device based shutdown hooks (preferable
> before PCI shutdown)

BTW, it would be better if DMA ram range was registered there too.

> (2) make sure GART is never enabled in kernels that are all < 4GB (as
> in the kdump kernel). But what to do about AGP?
yeah, AGP bridge will enable GART already.

YH
