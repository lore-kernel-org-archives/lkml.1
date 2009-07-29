Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZG2NsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZG2NsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755614AbZG2NsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:48:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:42902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603AbZG2NsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:48:17 -0400
Message-ID: <4A705321.6070502@suse.de>
Date: Wed, 29 Jul 2009 15:48:17 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] kvm/svm: copy only necessary parts of the control
 area on vmrun/vmexit
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com> <1248872192-30881-6-git-send-email-joerg.roedel@amd.com> <4A704ED9.2000604@suse.de> <20090729134714.GJ18313@amd.com>
In-Reply-To: <20090729134714.GJ18313@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Wed, Jul 29, 2009 at 03:30:01PM +0200, Alexander Graf wrote:
>   
>> Joerg Roedel wrote:
>>     
>>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>>>   
>>>       
>> What's the reason behind this?
>>
>> Acked-by: Alexander Graf <agraf@suse.de>
>>     
>
> Reason is to not copy the reserved fields of the control area. These
> fields sum up to size of 899 bytes which are unnecessarily copied.
>   

Fair enough :-)

