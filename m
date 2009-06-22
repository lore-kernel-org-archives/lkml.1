Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZFVJvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZFVJvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZFVJvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:51:32 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:8853 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751261AbZFVJvb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:51:31 -0400
X-SpamScore: -36
X-BigFish: VPS-36(zz1432R98dR936eN1805M9371Pzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLMWN7-03-89V-01
Date: Mon, 22 Jun 2009 11:49:53 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v3] KVM support for 1GB pages
Message-ID: <20090622094953.GE5139@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <4A3CC1FA.2070900@redhat.com> <20090622094013.GD5139@amd.com> <4A3F524C.8030902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A3F524C.8030902@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Jun 2009 09:49:54.0029 (UTC) FILETIME=[CB3079D0:01C9F31E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 12:43:40PM +0300, Avi Kivity wrote:
> On 06/22/2009 12:40 PM, Joerg Roedel wrote:
>>> Can you describe how the code fails with shadow paging?
>>>      
>>
>> After the rework it even fails to boot a guest with gbpages enabled. This week
>> is a bit tight but I will debug this further next week.
>>    
>
> Does the failure happen only when both guest/host use gbpages, or does  
> it also happen if gbpages is disabled on either one?

It happens only when the guest uses gbpages. If I disable them at boot the
linux guest boots fine and runs stable.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

