Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbXH0Wvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbXH0Wvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXH0Wvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:51:35 -0400
Received: from mga07.intel.com ([143.182.124.22]:42980 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753620AbXH0Wve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:51:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="268687600"
Message-ID: <46D354DD.6000208@linux.intel.com>
Date: Mon, 27 Aug 2007 15:49:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Eugene Teo <eugeneteo@kernel.sg>,
       linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] clean up exports in fs/{open,read_write}.c
References: <20070824033310.GA5662@kernel.sg> <20070827213747.GA17049@infradead.org>
In-Reply-To: <20070827213747.GA17049@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Aug 24, 2007 at 11:33:10AM +0800, Eugene Teo wrote:
>> Takashi-san fixed sound/isa/wavefront/wavefront_synth.c to use
>> request_firmware instead of sys_*. Since that is the last driver in the
>> kernel that uses sys_{read,close}, this patch kills these exports. sys_open
>> is left exported for sparc64 only.
> 
> I can't find any spar user of it, so please kill it.  

it's in the solaris compat code which is modular


> In the case a symbol
> is needed only for a particular architecture it's better to do it in the
> architecture-specific ksyms file than with an ifdef, btw.

agreed.
(well if it's only 1 or 2, if it's "half of them" it's obviously a 
different story)
