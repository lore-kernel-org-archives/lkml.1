Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFDMTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFDMTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZFDMTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:19:17 -0400
Received: from ns1.siteground150.com ([67.15.243.6]:58158 "EHLO
	serv01.siteground150.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZFDMTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:19:17 -0400
MIME-Version: 1.0
Date: Thu, 04 Jun 2009 07:19:10 -0500
From: <lkml@reliableembeddedsystems.com>
To: balbir@linux.vnet.ibm.com
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Robert Berger <robert.berger@reliableembeddedsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: http://patchwork.kernel.org/patch/26483/ broke my system boot
In-Reply-To: <20090604073240.GC7504@balbir.in.ibm.com>
References: <20090603143944.GF29326@balbir.in.ibm.com> <20090603194526.GG3100@uranus.ravnborg.org> <20090604063144.GB7504@balbir.in.ibm.com> <21fac393599ff68ff8edab1bade68ab2@reliableembeddedsystems.com> <20090604073240.GC7504@balbir.in.ibm.com>
Message-ID: <bf880e5a7d70d6f19345403cd1560e62@reliableembeddedsystems.com>
User-Agent: RoundCube Webmail/0.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground150.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - reliableembeddedsystems.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

Even when I do a native compile things look good to me.

make v=1 INSTALL_MOD_PATH=/tmp modules_install

  INSTALL arch/x86/crypto/aes-i586.ko
  INSTALL arch/x86/crypto/salsa20-i586.ko
  INSTALL arch/x86/crypto/twofish-i586.ko
  INSTALL arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.ko
  ... and so on until the end.

Is the depmod in your default path /sbin/depmod or something else?

Do you have the environment variable DEPMOD defined?

Do you see any errors when you do make modules_install with my patch?

Regards,

Robert

On Thu, 4 Jun 2009 15:32:40 +0800, Balbir Singh <balbir@linux.vnet.ibm.com>
wrote:
> * lkml@reliableembeddedsystems.com <lkml@reliableembeddedsystems.com>
> [2009-06-04 01:47:18]:
> 
>> Hi Balbir and all,
>> 
>> Sorry for the trouble and the missing changelog. I'm still learning;)
>> 
>> Can you please elaborate a bit more what exactly is broken?
>> Are you cross- or native compiling?
>> 
> 
> I am doing a native compile.
