Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZESNL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZESNL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZESNLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:11:21 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:58650 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbZESNLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:11:21 -0400
Date: Tue, 19 May 2009 09:10:51 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: devzero@web.de, david@lang.hm, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Where do we stand with the Xen patches?
Message-ID: <20090519131051.GA11318@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, devzero@web.de,
	david@lang.hm, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <720427516@web.de> <4A10BFE8.9020703@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A10BFE8.9020703@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A12AFDE.01C4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 06:54:48PM -0700, Jeremy Fitzhardinge wrote:
> devzero@web.de wrote:
>> or is maintaining two different kernel packages a problem?
>>   
>
> Yes, distros hate the proliferation of kernel packages with different  
> config options, partly because of the combinatorial explosion (32 vs 64,  
> UP vs SMP, PAE vs non-PAE...).  An explicit design intent of all the Xen  
> work is that it can be compile-time enabled without any (significant)  
> effect on native performance, so that the decision to enable Xen doesn't  
> have any downsides (either in terms of raw performance or maintenance of  
> the kernel package).

There is a long list of CONFIG_* that had performance impacts when
enabled later had that impact tuned away.  Especially now that
the source of the performance problem is understood, it makes sense to
me to merge and then focus energy on fixing it in tree instead of
spending time maintaining the out of tree patches.

-chris
