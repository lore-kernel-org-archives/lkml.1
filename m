Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbXB0Qps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbXB0Qps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXB0Qps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:45:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbXB0Qpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:45:47 -0500
Date: Tue, 27 Feb 2007 11:44:27 -0500
From: Dave Jones <davej@redhat.com>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@novell.com>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 1/3]cpuidle take2: Core cpuidle infrastructure
Message-ID: <20070227164427.GB2223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org,
	Adam Belay <abelay@novell.com>, Shaohua Li <shaohua.li@intel.com>,
	Len Brown <len.brown@intel.com>
References: <20070222135257.A26335@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222135257.A26335@unix-os.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 01:52:57PM -0800, Venkatesh Pallipadi wrote:

 > Announcing 'cpuidle', a new CPU power management infrastructure to manage
 > idle CPUs in a clean and efficient manner.
 > cpuidle separates out the drivers that can provide support for multiple types
 > of idle states and policy governors that decide on what idle state to use
 > at run time.
 > A cpuidle driver can support multiple idle states based on parameters like
 > varying power consumption, wakeup latency, etc (ACPI C-states for example).
 > A cpuidle governor can be usage model specific (laptop, server,
 > laptop on battery etc).
 > Main advantage of the infrastructure being, it allows independent development
 > of drivers and governors and allows for better CPU power management.

I played with this a little, and got puzzled.
My quad core box used exactly the same amount of power whether the
'ladder' governer was loaded & in use or not.  In both situations
it was exactly the same as a vanilla 2.6.20

I'd have expected it to use more until I loaded up 'ladder' to bring it
on par featurewise with 2.6.20.  What did I miss?

		Dave

-- 
http://www.codemonkey.org.uk
