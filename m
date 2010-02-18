Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0BROyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:54:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0BROym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:54:42 -0500
Message-ID: <4B7D54AD.5080601@redhat.com>
Date: Thu, 18 Feb 2010 16:54:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] Nested SVM fixes (and Win7-64bit bringup)
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com> <4B7D4FBA.2030204@redhat.com> <9769FCB3-A4E4-4934-808C-A83ADCC72356@suse.de>
In-Reply-To: <9769FCB3-A4E4-4934-808C-A83ADCC72356@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 04:48 PM, Alexander Graf wrote:
> On 18.02.2010, at 15:33, Avi Kivity wrote:
>
>    
>> On 02/18/2010 01:38 PM, Joerg Roedel wrote:
>>      
>>> Hi,
>>>
>>> here is a couple of fixes for the nested SVM implementation. I collected these
>>> fixes mostly when trying to get Windows 7 64bit running as an L2 guest. Most
>>> important fixes in this set make lazy fpu switching working with nested SVM and
>>> the nested tpr handling fixes. Without the later fix the l1 guest freezes when
>>> trying to run win7 as l2 guest. Please review and comment on these patches :-)
>>>
>>>        
>> Overall looks good.  Would appreciate Alex looking over these as well.
>>      
> The kmap thing is broken though, right?
>    

Oh yes, but that's a search and replace, not something needing deep rework.

-- 
error compiling committee.c: too many arguments to function

