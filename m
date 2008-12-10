Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYLJGaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYLJGaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 01:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbYLJGaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 01:30:13 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:38597 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYLJGaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 01:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=eVeW9d4nqcIBSbnIAq6Z38u4c9rq6YpnibG+Gv4/BE4IEXMNESCGjecUXAAwq0+kF3
         rrOyQpE4K1VR5OcNP41hO9yX/tmbUpguKIAtTDUog3eviMYs65EbeNow0rqiXDVT0oRZ
         AfSQH1OB2pmBacXHfLPaoGxUyVCqbY9m4K+iA=
Message-ID: <c2178680812092230t493b9212pdfb721cde15bf89a@mail.gmail.com>
Date: Wed, 10 Dec 2008 14:30:10 +0800
From: "Zhiwen Zheng" <zhiwen.zh@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IP over Fibre Channel slower than GigaEthernet ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To compare tcp transport speed of IP over FC to that of GigaEthernet,
I have two machines connected directly with FC or GigaEther, and run
ttcp to get the result.

configuration of the machines:
kernel version : 2.6.10
platform : xscale iop80331 500MHz
memory : 512MB DDR2
FC controller : LSI FC949x (using driver mptlan.c)
GigaEthernet controller : Intel 82546EB


In the Ethernet case,  the transport speed is about 90MB/s,
and cpu usage is about 90%.

In the FC case, the transport speed is about 60MB/s,
and cpu usage is also about 90%.

 Could someone tell me why FC is slower than GigaEthernet?
And is it possible to reduce the cpu usage through DMA or something else ?

Thanks.
