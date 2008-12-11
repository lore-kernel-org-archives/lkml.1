Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYLKBYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYLKBYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYLKBYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:24:39 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:33517 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbYLKBYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cZi3hMr/WGXMGcrUSVX0nKwOj/8f4nvd1FAADEv/6gfQKoPeddE6g+G5CPumNODsQh
         vBSSzt4ME5d1xudKDeIOWe0snXL/oFEmniLFKvh7ZGoX9GdjfC5ZTgLpC56yH+LYA6+i
         UstWNXg9iioVhFLdKYhdlqRbO2KP8W8OqIQJ8=
Message-ID: <c2178680812101724o40df531aw2390e08e2938f4bb@mail.gmail.com>
Date: Thu, 11 Dec 2008 09:24:37 +0800
From: "Zhiwen Zheng" <zhiwen.zh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: IP over Fibre Channel slower than GigaEthernet ?
In-Reply-To: <c2178680812092230t493b9212pdfb721cde15bf89a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c2178680812092230t493b9212pdfb721cde15bf89a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone point me to resources about doing zero copy in kernel,
such as RDMA over IP, RDMA over FC , please?

2008/12/10 Zhiwen Zheng <zhiwen.zh@gmail.com>:
> Hi,
>
> To compare tcp transport speed of IP over FC to that of GigaEthernet,
> I have two machines connected directly with FC or GigaEther, and run
> ttcp to get the result.
>
> configuration of the machines:
> kernel version : 2.6.10
> platform : xscale iop80331 500MHz
> memory : 512MB DDR2
> FC controller : LSI FC949x (using driver mptlan.c)
> GigaEthernet controller : Intel 82546EB
>
>
> In the Ethernet case,  the transport speed is about 90MB/s,
> and cpu usage is about 90%.
>
> In the FC case, the transport speed is about 60MB/s,
> and cpu usage is also about 90%.
>
>  Could someone tell me why FC is slower than GigaEthernet?
> And is it possible to reduce the cpu usage through DMA or something else ?
>
> Thanks.
>
