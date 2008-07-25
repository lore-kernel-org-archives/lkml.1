Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYGYA1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYGYA1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYGYA1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:27:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51475 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752193AbYGYA1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:27:22 -0400
Message-ID: <48891DDF.7090903@sgi.com>
Date: Thu, 24 Jul 2008 17:27:11 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
References: <20080723171841.815234000@polaris-admin.engr.sgi.com>	 <20080723171841.997896000@polaris-admin.engr.sgi.com> <36ca99e90807240556j6b409a03s239d781baaadbb99@mail.gmail.com> <4888B89E.9010708@sgi.com>
In-Reply-To: <4888B89E.9010708@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Bert Wesarg wrote:
:
> 
> .... Second, why do you want to set the last unsigned long to
>> one? Shouldn't this be the first?
> 
> The MSB of the cpumask is the highest numbered cpu, the LSB is the lowest.
> (Caught me early on as well.)

Forget what I said.  I was thinking of how the cpumask_scnprintf prints out
the cpumask and assumed (incorrectly) the bit layout was the same.  

Mike
