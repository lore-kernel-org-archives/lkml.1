Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZFHV34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZFHV34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZFHV3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:29:48 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46910 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZFHV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:29:48 -0400
Message-ID: <4A2D82CE.9000206@linux.vnet.ibm.com>
Date: Mon, 08 Jun 2009 14:29:50 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
References: <1244481941.13761.9119.camel@twins> <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop>
In-Reply-To: <1244496223.6691.2.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Mon, 2009-06-08 at 14:18 -0700, Corey Ashford wrote:
>> pca.ext_attrs = &feature.head; /* secretly know that there's data that lies past 
>> the attr struct header */
> 
> Right, except its not so very secret since we have the type field
> telling us.

I see.  Thanks for the explanation.  Looks like a good plan to me!

- Corey

