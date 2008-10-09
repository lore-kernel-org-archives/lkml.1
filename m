Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYJIRZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYJIRZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYJIRZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:25:11 -0400
Received: from gw.goop.org ([64.81.55.164]:36338 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYJIRZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:25:09 -0400
Message-ID: <48EE3E71.8010604@goop.org>
Date: Thu, 09 Oct 2008 10:25:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: "Cihula, Joseph" <joseph.cihula@intel.com>
CC: linux-kernel@vger.kernel.org, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cihula, Joseph wrote:
> --- a/security/Kconfig	Mon Oct 06 12:50:47 2008 -0700
> +++ b/security/Kconfig	Tue Oct 07 00:13:02 2008 -0700
> @@ -115,6 +115,23 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
>  	  /proc/sys/vm/mmap_min_addr tunable.
>  
>  
> +config TXT
>   

This should be X86_TXT; perhaps even X86_INTEL_TXT unless someone else 
is likely to implement this stuff.  ("TXT" is awfully generic.)


> +        bool "Enable Intel(R) Trusted Execution Technology (TXT)"
> +        depends on EXPERIMENTAL && X86
> +        help
> +          This option enables support for booting the kernel with
> +          the Trusted Boot (tboot) module. This will utilize
> +          Intel(R) Trusted Execution Technology (TXT) to perform a
> +          measured launch of the kernel. If the system does not
> +          support TXT, this will have no effect.
> +
> +          See <http://www.intel.com/technology/security/> for more
> +          information about Intel(R) TXT.
> +          And see <http://tboot.sourceforge.net> for more information
> +          about tboot.
> +
> +          If you are unsure as to whether this is required, answer N.
> +
>  source security/selinux/Kconfig
>  source security/smack/Kconfig
>   

    J
