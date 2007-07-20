Return-Path: <linux-kernel-owner+w=401wt.eu-S940616AbXGTQ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940616AbXGTQ3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936942AbXGTQ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:29:10 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56377 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921AbXGTQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:29:08 -0400
Message-ID: <46A0E2A9.6000308@s5r6.in-berlin.de>
Date: Fri, 20 Jul 2007 18:28:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: "clameter@sgi.com" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
References: <20070531002047.702473071@sgi.com>	 <20070531003012.302019683@sgi.com> <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com>
In-Reply-To: <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I missed the original post, hence am replying to te reply...)
> On 5/31/07, clameter@sgi.com <clameter@sgi.com> wrote:
>> Introduce CONFIG_STABLE to control checks only useful for development.
>>
>> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>> [...]
>>  menu "General setup"
>>
>> +config STABLE
>> +       bool "Stable kernel"
>> +       help
>> +         If the kernel is configured to be a stable kernel then various
>> +         checks that are only of interest to kernel development will be
>> +         omitted.
>> +

Didn't we talk about the wording and the logic some time ago?  Your
option looks like a magic switch that suddenly improves kernel
stability, hence everyone will switch it on.

How about this:

config BUILD_FOR_RELEASE
	bool "Build for release"
	help
	  If the kernel is configured as a release build, various checks
	  that are only of interest to kernel development will be
	  omitted.

	  If unsure, say Y.

Or this:

config BUILD_FOR_TESTING
	bool "Build for testing"
	help
	  If the kernel is configured as a test build, various checks
	  useful for testing of pre-releases will be activated.

	  If unsure, say N.
-- 
Stefan Richter
-=====-=-=== -=== =-=--
http://arcgraph.de/sr/
