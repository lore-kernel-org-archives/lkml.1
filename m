Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZLWCGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZLWCGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 21:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZLWCGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 21:06:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:59626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZLWCGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 21:06:00 -0500
Message-ID: <4B317B98.7080109@kernel.org>
Date: Wed, 23 Dec 2009 11:08:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V8 09/16] Allow arch to provide inc/dec functionality
 for each size separately
References: <20091218222617.384355422@quilx.com> <20091218222652.446462888@quilx.com> <4B2F2305.8030001@kernel.org> <alpine.DEB.2.00.0912220955010.12163@router.home>
In-Reply-To: <alpine.DEB.2.00.0912220955010.12163@router.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On 12/23/2009 12:56 AM, Christoph Lameter wrote:
> On Mon, 21 Dec 2009, Tejun Heo wrote:
> 
>> On 12/19/2009 07:26 AM, Christoph Lameter wrote:
>>> Current this_cpu ops only allow an arch to specify add RMW operations or inc
>>> and dec for all sizes. Some arches can do more efficient inc and dec
>>> operations. Allow size specific override of fallback functions like with
>>> the other operations.
>>
>> Wouldn't it be better to use __builtin_constant_p() and switching in
>> arch add/dec macros?  It just seems a bit extreme to define all those
> 
> Yes that could be done but I am on vacation till next year ;-)...

I'm not sure how much I would be working from now till the end of the
year but if I end up doing some work I'll give it a shot.

Happy holidays and enjoy your vacation!

-- 
tejun
