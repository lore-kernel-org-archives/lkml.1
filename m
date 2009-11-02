Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZKBQPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZKBQPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZKBQPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:15:16 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42902 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbZKBQPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:15:15 -0500
Message-ID: <4AEF0597.9030805@austin.ibm.com>
Date: Mon, 02 Nov 2009 10:15:19 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v5] CPU DLPAR Handling
References: <4AE8ADCF.6090104@austin.ibm.com>	 <4AE8B0B1.4020102@austin.ibm.com> <1256786763.26770.46.camel@pasglop>
In-Reply-To: <1256786763.26770.46.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2009-10-28 at 15:59 -0500, Nathan Fontenot wrote:
> 
>> +#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
>> +static ssize_t cpu_probe(const char *buf, size_t count)
> 
> dlpar_cpu_probe() pls
> 
>> +static ssize_t cpu_release(const char *buf, size_t count)
>> +{
> 
> Ditto.
> 
> Or else in system.map, backtraces, etc... it's hard to figure out off
> hand where it's dying :-)

Good point, I'll fix this.

-Nathan

> 
> Cheers,
> Ben.
> 
> 
