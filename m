Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0BVR7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:59:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0BVR7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:59:05 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=gBUr1MAetDtUQIFfWl0A:9 a=dp2HRQ-t2szm_CLU_qAAypJ5hUYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] scripts: improve checkstack
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Cong Wang <amwang@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Hui Zhu <teawater@gmail.com>,
       Ozan =?ISO-8859-1?Q?=C3aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4B82B7B0.7040203@linux.intel.com>
References: <20100219175217.385580142@vyatta.com>
	 <20100219175429.611463369@vyatta.com>	<4B7F5128.70501@redhat.com>
	 <20100219222554.17d4bae6@nehalam>	<4B7F90AA.8050306@redhat.com>
	 <20100222084339.1367cfe6@nehalam>  <4B82B7B0.7040203@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Feb 2010 12:59:00 -0500
Message-ID: <1266861540.24271.4609.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 08:58 -0800, Arjan van de Ven wrote:
> On 2/22/2010 8:43, Stephen Hemminger wrote:
> 
> 
> btw as a general comment on these guys
> 
> "make it more perl-ish" is not a good feature for me.
> 
> "make it more readable" would be.
> 
> these guys are not performance sensitive, lets make them as readable as possible, and not line noise.
> 

Acked-by: Steven Rostedt

That is, I've purposely did not do "perlish" code in the perl scripts
that I wrote, and have consistently NACKed changes to make it so.

The perl scripts in the kernel need to be "C-ish" not "perl-ish", that
way the other 70% of the kernel programmers that do not do perl can
still understand these scripts.

-- Steve


