Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYCaXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYCaXa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 19:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYCaXaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 19:30:21 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:39936 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYCaXaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:30:20 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Tue, 1 Apr 2008 01:30:16 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200804010001.51288.chunkeey@web.de> <200804010114.25810.rjw@sisk.pl>
In-Reply-To: <200804010114.25810.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804010130.17453.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18vOmcFCi20xNrI4IidufTV/CkNR/Ek7lS/GSfA
	b3GqzNlIQ6KcL7JmK5M52w/4zj1o9u725u8gG9sO/DfPwCz8ng
	mCg5EamuY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 01:14:24 Rafael J. Wysocki wrote:
> On Tuesday, 1 of April 2008, Chr wrote:
>
> Have you posted the .config already?
Done!

BTW:
[ 5074.308547]   .jiffies                       : 4296102117
[ 5074.308547]   .jiffies                       : 4296102117
[ 5105.659185]   .idle_jiffies   : 4296102113
[ 5105.659185]   .last_jiffies   : 4296102117
[ 5105.659185]   .next_jiffies   : 4296102118
[ 5105.659185] jiffies: 4296102117
[ 5105.659185]   .idle_jiffies   : 4296102114
[ 5105.659185]   .last_jiffies   : 4296102113
[ 5105.659185]   .next_jiffies   : 4296102116
[ 5105.659185] jiffies: 4296102117
[ 5044.543918]   .jiffies                       : 4296102117
[ 5044.640998]   .jiffies                       : 4296102117
[ 4979.215327]   .idle_jiffies   : 4296102113
[ 4979.229471]   .last_jiffies   : 4296102117
[ 4979.231334]   .next_jiffies   : 4296102118
[ 4979.235415] jiffies: 4296102117
[ 4979.298216]   .idle_jiffies   : 4296102114
[ 4979.312360]   .last_jiffies   : 4296102113
[ 4979.314223]   .next_jiffies   : 4296102116
[ 4979.318303] jiffies: 4296102117
[ 5040.749212]   .idle_jiffies   : 4296102113
[ 5040.763356]   .last_jiffies   : 4296102117
[ 5040.765219]   .next_jiffies   : 4296102118
[ 5040.769299] jiffies: 4296102117
[ 5040.832119]   .idle_jiffies   : 4296102114
[ 5040.846264]   .last_jiffies   : 4296102113
[ 5040.848127]   .next_jiffies   : 4296102116
[ 5040.852206] jiffies: 4296102117
-OUCH - going backwards?
[ 4956.514210]   .idle_jiffies   : 4296102113
[ 4956.528354]   .last_jiffies   : 4296102117
[ 4956.530217]   .next_jiffies   : 4296102118
[ 4956.534298] jiffies: 4296102117
[ 4956.597024]   .idle_jiffies   : 4296102114
[ 4956.611168]   .last_jiffies   : 4296102113
[ 4956.613031]   .next_jiffies   : 4296102116
[ 4956.617111] jiffies: 4296102117
[ 5063.325509]   .idle_jiffies   : 4296102113
[ 5063.339653]   .last_jiffies   : 4296102117
[ 5063.341517]   .next_jiffies   : 4296102118
[ 5063.345597] jiffies: 4296102117
[ 5063.408519]   .idle_jiffies   : 4296102114
[ 5063.422664]   .last_jiffies   : 4296102113
[ 5063.424526]   .next_jiffies   : 4296102116
[ 5063.428607] jiffies: 4296102117
[ 5116.186763]   .idle_jiffies   : 4296102113
[ 5116.186764]   .last_jiffies   : 4296102117
[ 5116.186764]   .next_jiffies   : 4296102118
[ 5116.186764] jiffies: 4296102117
[ 5116.186764]   .idle_jiffies   : 4296102114
[ 5116.186764]   .last_jiffies   : 4296102113
[ 5116.186764]   .next_jiffies   : 4296102116
[ 5116.186764] jiffies: 4296102117
[ 5012.429020]   .idle_jiffies   : 4296102113
[ 5012.443164]   .last_jiffies   : 4296102117
[ 5012.445027]   .next_jiffies   : 4296102118
[ 5012.449107] jiffies: 4296102117
[ 5012.511908]   .idle_jiffies   : 4296102114
[ 5012.526052]   .last_jiffies   : 4296102113
[ 5012.527915]   .next_jiffies   : 4296102116
[ 5012.531995] jiffies: 4296102117
[ 5048.890792]   .idle_jiffies   : 4296102113
[ 5048.904936]   .last_jiffies   : 4296102117
[ 5048.906800]   .next_jiffies   : 4296102118
[ 5048.910880] jiffies: 4296102117
[ 5048.973842]   .idle_jiffies   : 4296102114
[ 5048.987987]   .last_jiffies   : 4296102113
[ 5048.989850]   .next_jiffies   : 4296102116
[ 5048.993930] jiffies: 4296102117
[ 5069.025049]   .idle_jiffies   : 4296102113
[ 5069.039194]   .last_jiffies   : 4296102117
[ 5069.041056]   .next_jiffies   : 4296102118
[ 5069.045136] jiffies: 4296102117
[ 5069.107874]   .idle_jiffies   : 4296102114
[ 5069.122019]   .last_jiffies   : 4296102113
[ 5069.123881]   .next_jiffies   : 4296102116
[ 5069.127962] jiffies: 4296102117
[ 5095.978692]   .idle_jiffies   : 4296102113
[ 5095.992836]   .last_jiffies   : 4296102117
[ 5095.994699]   .next_jiffies   : 4296102118
[ 5095.998780] jiffies: 4296102117
[ 5096.061623]   .idle_jiffies   : 4296102114
[ 5096.075768]   .last_jiffies   : 4296102113
[ 5096.077631]   .next_jiffies   : 4296102116
[ 5096.081711] jiffies: 4296102117
[ 5108.211902]   .idle_jiffies   : 4296102113
[ 5108.211902]   .last_jiffies   : 4296102117
[ 5108.211902]   .next_jiffies   : 4296102118
[ 5108.211902] jiffies: 4296102117
[ 5108.211903]   .idle_jiffies   : 4296102114
[ 5108.211903]   .last_jiffies   : 4296102113
[ 5108.211903]   .next_jiffies   : 4296102116
[ 5108.211903] jiffies: 4296102117
[ 5108.211903]   .idle_jiffies   : 4296102113
[ 5108.211903]   .last_jiffies   : 4296102117
[ 5108.211903]   .next_jiffies   : 4296102118
[ 5108.211903] jiffies: 4296102117
[ 5108.211903]   .idle_jiffies   : 4296102114
[ 5108.211903]   .last_jiffies   : 4296102113
[ 5108.211903]   .next_jiffies   : 4296102116
[ 5108.211903] jiffies: 4296102117
[ 5108.211903]   .idle_jiffies   : 4296102113
[ 5108.211903]   .last_jiffies   : 4296102117
[ 5108.211903]   .next_jiffies   : 4296102118
[ 5108.211903] jiffies: 4296102117
[ 5108.211903]   .idle_jiffies   : 4296102114
[ 5108.211903]   .last_jiffies   : 4296102113
[ 5108.211903]   .next_jiffies   : 4296102116
[ 5108.211903] jiffies: 4296102117
[ 5108.211904]   .idle_jiffies   : 4296102113
[ 5108.211904]   .last_jiffies   : 4296102117
[ 5108.211904]   .next_jiffies   : 4296102118
[ 5108.211904] jiffies: 4296102117
[ 5108.211904]   .idle_jiffies   : 4296102114
[ 5108.211904]   .last_jiffies   : 4296102113
[ 5108.211904]   .next_jiffies   : 4296102116
[ 5108.211904] jiffies: 4296102117
[ 5108.211904]   .idle_jiffies   : 4296102113
[ 5108.211904]   .last_jiffies   : 4296102117
[ 5108.211904]   .next_jiffies   : 4296102118
[ 5108.211904] jiffies: 4296102117
[ 5108.211904]   .idle_jiffies   : 4296102114
[ 5108.211904]   .last_jiffies   : 4296102113
[ 5108.211904]   .next_jiffies   : 4296102116
[ 5108.211904] jiffies: 4296102117
[ 5108.211905]   .idle_jiffies   : 4296102113
[ 5108.211905]   .last_jiffies   : 4296102117
[ 5108.211905]   .next_jiffies   : 4296102118
[ 5108.211905] jiffies: 4296102117
[ 5108.211905]   .idle_jiffies   : 4296102114
[ 5108.211905]   .last_jiffies   : 4296102113
[ 5108.211905]   .next_jiffies   : 4296102116
[ 5108.211905] jiffies: 4296102117
[ 5108.211905]   .idle_jiffies   : 4296102113
[ 5108.211905]   .last_jiffies   : 4296102117
[ 5108.211905]   .next_jiffies   : 4296102118
[ 5108.211905] jiffies: 4296102117
[ 5108.211905]   .idle_jiffies   : 4296102114
[ 5108.211905]   .last_jiffies   : 4296102113
[ 5108.211905]   .next_jiffies   : 4296102116
[ 5108.211905] jiffies: 4296102117
[ 5108.211905]   .idle_jiffies   : 4296102113
[ 5108.211905]   .last_jiffies   : 4296102117
[ 5108.211905]   .next_jiffies   : 4296102118
[ 5108.211905] jiffies: 4296102117
[ 5108.211906]   .idle_jiffies   : 4296102114
[ 5108.211906]   .last_jiffies   : 4296102113
[ 5108.211906]   .next_jiffies   : 4296102116
[ 5108.211906] jiffies: 4296102117
[ 5108.211906]   .idle_jiffies   : 4296102113
[ 5108.211906]   .last_jiffies   : 4296102117
[ 5108.211906]   .next_jiffies   : 4296102118
[ 5108.211906] jiffies: 4296102117
[ 5108.211906]   .idle_jiffies   : 4296102114
[ 5108.211906]   .last_jiffies   : 4296102113
[ 5108.211906]   .next_jiffies   : 4296102116
[ 5108.211906] jiffies: 4296102117
[ 5108.211906]   .idle_jiffies   : 4296102113
[ 5108.211906]   .last_jiffies   : 4296102117
[ 5108.211906]   .next_jiffies   : 4296102118
[ 5108.211906] jiffies: 4296102117
[ 5108.211906]   .idle_jiffies   : 4296102114
[ 5108.211906]   .last_jiffies   : 4296102113
[ 5108.211906]   .next_jiffies   : 4296102116
[ 5108.211906] jiffies: 4296102117
[ 5108.211924]   .jiffies                       : 4296102117
[ 5108.211925]   .jiffies                       : 4296102117

Regards,
	Chr
