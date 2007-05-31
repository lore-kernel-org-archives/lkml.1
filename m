Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbXEaJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbXEaJEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbXEaJD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:03:59 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:58883 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760095AbXEaJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:03:57 -0400
Message-ID: <465E8F7C.7080300@s5r6.in-berlin.de>
Date: Thu, 31 May 2007 11:03:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: clameter@sgi.com
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
References: <20070531002047.702473071@sgi.com> <20070531003012.302019683@sgi.com> <465E8D4C.9040506@s5r6.in-berlin.de>
In-Reply-To: <465E8D4C.9040506@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  menu "General setup"
>>  
>> +config STABLE
>> +	bool "Stable kernel"
[...]
> a) Why in Kconfig, why not in Makefile?
> 
> b) Of course nobody wants STABLE=n. :-)  How about:
> 
> config RELEASE
> 	bool "Build for release"
> 	help
> 	  If the kernel is declared as a release build here, then
> 	  various checks that are only of interest to kernel development
> 	  will be omitted.

PS:  Also, it could be reversed (e.g. config TESTBUILD) and put into the
Kernel Hacking submenu.

> c) A drawback of this general option is, it's hard to tell what will be
> omitted in particular.

-- 
Stefan Richter
-=====-=-=== -=-= =====
http://arcgraph.de/sr/
