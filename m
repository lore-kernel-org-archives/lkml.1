Return-Path: <linux-kernel-owner+w=401wt.eu-S965574AbXBTADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574AbXBTADU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXBTACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:02:35 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:52783 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965580AbXBTACc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:02:32 -0500
Date: Mon, 19 Feb 2007 19:02:31 -0500
To: takada <takada@mbf.nifty.com>
Cc: rdreier@cisco.com, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
Message-ID: <20070220000231.GM7585@csclub.uwaterloo.ca>
References: <20070217.231113.193678444.takada@mbf.nifty.com> <20070219145514.GO7582@csclub.uwaterloo.ca> <ada3b5253p0.fsf@cisco.com> <20070220.085639.260788422.takada@mbf.nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220.085639.260788422.takada@mbf.nifty.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 08:56:39AM +0900, takada wrote:
> /proc/cpuinfo with MediaGXm :
> 
> processor	: 0
> vendor_id	: CyrixInstead
> cpu family	: 5
> model		: 5
> model name	: Cyrix MediaGXtm MMXtm Enhanced
> stepping	: 2
> cpu MHz		: 199.750
> cache size	: 16 KB
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 2
> wp		: yes
> flags		: fpu tsc msr cx8 cmov mmx cxmmx
> bogomips	: 401.00
> clflush size	: 32

Hmm with 2.6.18 I am seeing:

processor       : 0
vendor_id       : CyrixInstead
cpu family      : 5
model           : 9
model name      : Geode(TM) Integrated Processor by National Semi
stepping        : 1
cpu MHz         : 266.648
cache size      : 16 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu tsc msr cx8 cmov mmx cxmmx
bogomips        : 534.50

Similar, but the last line isn't there.  It looks like 2.6.18 doesn't
actually have code to print that information though.

--
Len Sorensen
