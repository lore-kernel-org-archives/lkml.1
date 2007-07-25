Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXGYO4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXGYO4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758493AbXGYO4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:56:40 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:52717 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbXGYO4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:56:39 -0400
Message-ID: <46A76472.1060204@hp.com>
Date: Wed, 25 Jul 2007 10:55:46 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Adrian Bunk <bunk@stusta.de>, lksctp-developers@lists.sourceforge.net,
       Gabriel C <nix.or.die@googlemail.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Lksctp-developers] __unsafe() usage
References: <46A3FE3E.20300@googlemail.com>	 <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>	 <20070723175927.GM26212@stusta.de>	 <1185232601.1803.41.camel@localhost.localdomain>  <46A5F91B.50403@hp.com> <1185316027.1803.351.camel@localhost.localdomain>
In-Reply-To: <1185316027.1803.351.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tue, 2007-07-24 at 09:05 -0400, Vlad Yasevich wrote:
>> Please don't remove module_exit point for SCTP.  Simply removing the __unsafe() call will
>> be sufficient.
>>
>> The code has recently been cleaned up to allow safe unloading and I working on final
>> cleanups.  It currently works correctly with forced unloading.
> 
> Thanks Vlad!
> 
> I think that's everyone...

Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
