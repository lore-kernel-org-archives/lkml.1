Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbYG3Xsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbYG3Xsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYG3Xs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:48:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35509 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbYG3Xs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:48:26 -0400
Date: Thu, 31 Jul 2008 09:48:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
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
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use
 cpumask_of_cpu_map - build breakage
Message-Id: <20080731094816.3b5a53f4.sfr@canb.auug.org.au>
In-Reply-To: <4890E539.6060905@am.sony.com>
References: <20080723171841.815234000@polaris-admin.engr.sgi.com>
	<20080723171841.997896000@polaris-admin.engr.sgi.com>
	<4890C8E4.50503@am.sony.com>
	<4890DC09.2020700@sgi.com>
	<4890E539.6060905@am.sony.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Wed, 30 Jul 2008 15:03:37 -0700 Tim Bird <tim.bird@am.sony.com> wrote:
>
> I don't see 1eddd657 anywhere in the commit log for cpumask.h
> Is it in linux-next?

Yeah, that was the commit from next-20080730.  (one less patch I need to
apply :-))

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
