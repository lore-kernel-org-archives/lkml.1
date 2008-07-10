Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYGJWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYGJWJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYGJWJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:09:05 -0400
Received: from mga12.intel.com ([143.182.124.36]:11183 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753019AbYGJWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:09:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,340,1212390000"; 
   d="scan'208";a="11835827"
Message-ID: <4876887E.3080204@linux.intel.com>
Date: Thu, 10 Jul 2008 15:09:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, andi@firstfloor.org,
       jbarnes@virtuousgeek.org, steiner@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
 x2apic support
References: <20080710181634.764954000@linux-os.sc.intel.com> <m1prplv71d.fsf@frodo.ebiederm.org>
In-Reply-To: <m1prplv71d.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> A lot of your code is generic, and some of it is for just x86_64.  Since the
> cpus are capable of running in 32bit mode.  We really need to implement x86_32
> and x86_64 support in the same code base.  Which I believe means factoring out
> pieces of io_apic_N.c into things such as msi.c that can be shared between the
> two architectures.

in general the purpose of this is to support 256 and more logical threads....
.... not going to happen on 32 bit

