Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453Ab0ARMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0ARMyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874Ab0ARMyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab0ARMyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:54:12 -0500
Message-ID: <4B5459CA.9060603@redhat.com>
Date: Mon, 18 Jan 2010 14:53:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <1263740593.557.20967.camel@twins>	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
In-Reply-To: <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 02:51 PM, Pekka Enberg wrote:
>
> And how many probes do we expected to be live at the same time in
> real-world scenarios? I guess Avi's "one million" is more than enough?
>    

I don't think a user will ever come close to a million, but we can 
expect some inflation from inlined functions (I don't know if uprobes 
replicates such probes, but if it doesn't, it should).

-- 
error compiling committee.c: too many arguments to function

