Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274Ab0ATT5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0ATT5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703Ab0ATT5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:57:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0ATT5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:57:49 -0500
Message-ID: <4B576018.2000201@kernel.org>
Date: Wed, 20 Jan 2010 11:57:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/37] x86: check range in update range
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-3-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191055070.22304@router.home> <4B575C07.8080002@kernel.org> <alpine.DEB.2.00.1001201349540.15175@router.home>
In-Reply-To: <alpine.DEB.2.00.1001201349540.15175@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 11:50 AM, Christoph Lameter wrote:
> On Wed, 20 Jan 2010, Yinghai Lu wrote:
> 
>> On 01/19/2010 08:56 AM, Christoph Lameter wrote:
>>> On Fri, 15 Jan 2010, Yinghai Lu wrote:
>>>
>>>> fend off wrong range
>>>
>>> Why is it ok now to call these functions with start >= end? Bootmem
>>> compatibilty?
>>
>> and amd_bus/intel_bus etc will be use 32bit etc
> 
> Can you be more detailed?

need to cap resources for 32bit if the reading is > 4g.

YH
