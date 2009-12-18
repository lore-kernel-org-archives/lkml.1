Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZLRKTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZLRKTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZLRKTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:19:48 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:33920 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZLRKTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:19:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rstB/r3s5T+m9PXhtOluW2M0cRjpkjISLoQzrPcOO45x2uipndxnIkZMcg1eT4br+8
         d+XmVVVVGSZbvg5MCmk6oPpV3X8BOJHbdBOnC13gUZXYCQKTyFybqAvuWUwYDzqe4fZp
         FhmapkgI1JNA4Y7Su+wndeKBj9Z7F1jWjTbqI=
MIME-Version: 1.0
In-Reply-To: <200912181112.30586.a.miskiewicz@gmail.com>
References: <200912181112.30586.a.miskiewicz@gmail.com>
Date: Fri, 18 Dec 2009 02:19:47 -0800
X-Google-Sender-Auth: a1997c78ca28a1e8
Message-ID: <86802c440912180219j6aeb1480p7adbc5ced1113f4e@mail.gmail.com>
Subject: Re: what's node "-1" ?
From: Yinghai Lu <yinghai@kernel.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 2:12 AM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
>
> [   22.284175]   alloc irq_desc for 55 on node -1
> [   22.284177]   alloc kstat_irqs on node -1
>
> What's node "-1" ?
>
> dmesg talks about nodes such things:
> [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
> [    0.073337] CPU 0/0x0 -> Node 0
>
> there is some "node 0" ... but no idea what -1 is.

that mean for irq_desc related, alloc mem will use mem on
cpu_to_node(cpu) that code is runing

YH
