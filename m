Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXBSX6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXBSX6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXBSX6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:58:48 -0500
Received: from pxy2nd.nifty.com ([202.248.175.14]:44028 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965572AbXBSX6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:58:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=VHSwhYyVquDmdCuMozrTTehNjuwrgJEjW2unWEh9Hxgv2jz8RUqsf1E2Qt97sHBht14Hr4YiBOy95Fi5Ys22DQ==  ;
Date: Tue, 20 Feb 2007 08:56:39 +0900 (JST)
Message-Id: <20070220.085639.260788422.takada@mbf.nifty.com>
To: rdreier@cisco.com
Cc: lsorense@csclub.uwaterloo.ca, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
From: takada <takada@mbf.nifty.com>
In-Reply-To: <ada3b5253p0.fsf@cisco.com>
References: <20070217.231113.193678444.takada@mbf.nifty.com>
	<20070219145514.GO7582@csclub.uwaterloo.ca>
	<ada3b5253p0.fsf@cisco.com>
X-Mailer: Mew version 5.1 on Emacs 22.0.92 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
Date: Mon, 19 Feb 2007 11:48:27 -0800

>  > Does anyone know if there is any way to flush a cache line of the cpu to
>  > force rereading system memory for a given address or address range?
> 
> There is the "clflush" instruction, but not all x86 CPUs support it.
> You need to check the CPUID flag to know for sure (/proc/cpuinfo will
> show a "clflush" flag if it is supported).

/proc/cpuinfo with MediaGXm :

processor	: 0
vendor_id	: CyrixInstead
cpu family	: 5
model		: 5
model name	: Cyrix MediaGXtm MMXtm Enhanced
stepping	: 2
cpu MHz		: 199.750
cache size	: 16 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu tsc msr cx8 cmov mmx cxmmx
bogomips	: 401.00
clflush size	: 32
