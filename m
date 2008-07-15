Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbYGOS5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbYGOS5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGOS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:57:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55039 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbYGOS51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:57:27 -0400
Subject: Re: kvm causing memory corruption?  now 2.6.26-rc8
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
In-Reply-To: <48512028.3070104@qumranet.com>
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>
	 <47EA1C63.8010202@qumranet.com>
	 <1206550329.7883.5.camel@nimitz.home.sr71.net>
	 <47EA80AC.4070204@qumranet.com>
	 <1206551794.7883.7.camel@nimitz.home.sr71.net>
	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>
	 <1206629709.7883.30.camel@nimitz.home.sr71.net>
	 <47EBB63E.2060306@qumranet.com>
	 <1212445810.8211.9.camel@nimitz.home.sr71.net>
	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>
	 <48512028.3070104@qumranet.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 11:57:22 -0700
Message-Id: <1216148242.25942.6.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, just a continuation of what we were talking about before...

I just had a bug triggered on my system because I'm running sparsemem
(it was in show_mem()).  I wonder if sparsemem is contributing to the
bug.  Does kvm ever do any arithmetic that you can think of with 'struct
page's?

To summarize my config: 
* 4GB of RAM
* hole from 3-4GB (so ram ranges from 0-5GB)
* PAE enabled
* SPARSEMEM=y

http://sr71.net/~dave/linux/config-2.6.26-rc8-00089-ge1441b9

I'm compiling a kernel right now to try without sparsemem.

-- Dave

