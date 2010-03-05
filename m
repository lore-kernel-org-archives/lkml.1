Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0CERnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:43:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41318 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab0CERnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:43:05 -0500
Message-ID: <4B9142A1.7090605@linux.vnet.ibm.com>
Date: Fri, 05 Mar 2010 09:42:57 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
In-Reply-To: <4B8F1B58.5000702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I posted this yesterday, but I think LKML rejected it because there was more
quoted text than my text.  So I am reposting with no quoted text).

A couple of follow-up comments on this patch:

This functionality was designed to provide a generalized interface to an 
external event name -> attr struct library, such as libpfm4.  libpfm4 has an 
interface that nearly exactly matches parse_*_event() profiles, so it's quite 
easy to write a small wrapper function to call libpfm4's function.

Ingo Molnar discussed adding some visibility to the arch-dependent event names 
through some other interface, such as through /sys/devices/pmus perhaps, but 
that discussion is a long way (as far as I know) from having something usable 
today.  So you could think of this external library approach to be a stop-gap 
until something better is developed.  When/if that new event naming mechanism 
becomes available, we can easily remove this external library support from perf.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
cjashfor@us.ibm.com

