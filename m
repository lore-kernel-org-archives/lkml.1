Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0CCAax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:30:53 -0500
Received: from xenotime.net ([72.52.64.118]:58972 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754456Ab0CCAav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:30:51 -0500
Message-ID: <4B8DADB9.1040302@xenotime.net>
Date: Tue, 02 Mar 2010 16:30:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 2/2] x86: Manage ENERGY_PERF_BIAS based on cpufreq governor
References: <20100303000649.757684000@intel.com> <20100303000849.278509000@intel.com>
In-Reply-To: <20100303000849.278509000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/10 16:06, venkatesh.pallipadi@intel.com wrote:

{bah, more difficult to review an attachment, so no leading '>'}


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8c666d8..4945add 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -749,6 +749,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			Default value is 0.
 			Value can be changed at runtime via /selinux/enforce.
 
+	epb		[X86] Control IA32_ENERGY_PERF_BIAS setting
+			"disable" - Kernel will not modify this MSR
+			<0..15> - Kernel will set this MSR to i/p static value
+


Should be more like:

	epb=		[X86] Control IA32_ENERGY_PERF_BIAS setting
			Format: { disable | <0...15> }
			"disable" - Kernel will not modify this MSR
			<0..15> - Kernel will set this MSR to i/p static value


But what is "i/p"?  Use whatever word it should be, please.
What do the values mean?
And what does IA32 have to do with this?  does it not apply to x86_64?

thanks,
-- 
~Randy
