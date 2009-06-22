Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZFVJkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZFVJkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbZFVJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:40:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:44521 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZFVJkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:40:32 -0400
X-SpamScore: -36
X-BigFish: VPS-36(zz1432R98dR936eN1805M9371Pzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLMW72-04-U0P-01
Date: Mon, 22 Jun 2009 11:40:13 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v3] KVM support for 1GB pages
Message-ID: <20090622094013.GD5139@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <4A3CC1FA.2070900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A3CC1FA.2070900@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Jun 2009 09:40:13.0563 (UTC) FILETIME=[713464B0:01C9F31D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 02:03:22PM +0300, Avi Kivity wrote:
> On 06/19/2009 04:16 PM, Joerg Roedel wrote:
>> Hi,
>>
>> this is the third version of the patches for KVM to support 1GB pages. Changes
>> to the last version include:
>>
>> 	- changed reporting of 1GB page support to userspace to use
>> 	  SUPPORTED_CPUID ioctl
>> 	- added support for 1GB pages to the software page walker code too
>>
>> This code still only can make use of 1GB pages with nested paging enabled. I
>> will give the shadow paging code another debug round soon. Please comment or
>> consider to apply these patches.
>>
>>    
>
> Can you describe how the code fails with shadow paging?

After the rework it even fails to boot a guest with gbpages enabled. This week
is a bit tight but I will debug this further next week.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

