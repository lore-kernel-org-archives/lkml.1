Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYC3NmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYC3NmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 09:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYC3Nlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 09:41:55 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58593
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYC3Nly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 09:41:54 -0400
Message-ID: <47EF98A0.4020903@qumranet.com>
Date: Sun, 30 Mar 2008 16:41:52 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Isaku Yamahata <yamahata@valinux.co.jp>, eddie.dong@intel.com,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, xen-ia64-devel@lists.xensource.com
Subject: Re: [PATCH 09/12] xen: make include/xen/page.h portable moving those
 definitions under asm dir.
References: <12067044183207-git-send-email-yamahata@valinux.co.jp>	<12067044183655-git-send-email-yamahata@valinux.co.jp> <47ED57E8.4050506@goop.org>
In-Reply-To: <47ED57E8.4050506@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Isaku Yamahata wrote:
>   
>> The definitions in include/asm/xen/page.h are arch specific.
>> ia64/xen wants to define its own version. So move them to arch specific
>> directory and keep include/xen/page.h in order not to break compilation.
>>
>> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
>> ---
>>  include/{ => asm-x86}/xen/page.h |    0 
>>  include/xen/page.h               |  169 +-------------------------------------
>>  2 files changed, 1 insertions(+), 168 deletions(-)
>>  copy include/{ => asm-x86}/xen/page.h (100%)
>>
>> diff --git a/include/xen/page.h b/include/asm-x86/xen/page.h
>> similarity index 100%
>> copy from include/xen/page.h
>> copy to include/asm-x86/xen/page.h
>> diff --git a/include/xen/page.h b/include/xen/page.h
>>   
>>     
>
> Is this a magic git-format patch, or is it simply missing 
> asm-x86/xen/page.h?
>
>   

Magic git format.  Look at lines beginning with 'copy' above.

(a better result would have been a move along with a creation of a new 
include/xen/page.h)

-- 
error compiling committee.c: too many arguments to function

