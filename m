Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZKKPA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZKKPA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZKKPAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:00:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbZKKPAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:00:54 -0500
Message-ID: <4AFAD172.4090003@redhat.com>
Date: Wed, 11 Nov 2009 17:00:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>,
       Jamie Lokier <jamie@shareable.org>,
       Anthony Liguori <aliguori@us.ibm.com>, agl@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] Re: virtio: Add memory statistics reporting to the
 balloon driver
References: <1257782838.2835.5.camel@aglitke>	 <1257784326.2835.16.camel@aglitke>	 <200911101312.02650.rusty@rustcorp.com.au> <4AF97A5E.1070801@codemonkey.ws>	 <4AF97C1A.2080609@redhat.com> <4AF97F93.2080707@us.ibm.com>	 <20091111092409.GA24646@shareable.org>  <20091111101223.GA22937@redhat.com> <1257945984.2876.1.camel@aglitke>
In-Reply-To: <1257945984.2876.1.camel@aglitke>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 03:26 PM, Adam Litke wrote:
> On Wed, 2009-11-11 at 10:12 +0000, Daniel P. Berrange wrote:
>    
>> This all suggests that we should only update the stats from the guest
>> when something on the host actually asks for them by issuing the QEMU
>> monitor command. We don't want any kind of continuous polling of stats
>> at any frequency, if nothing is using these stats on the host.
>>      
> Agreed.  The next version of the patch will remove the timer completely.
> We'll wake up in response to config change notifications only.
>    

A vq with its own interrupt would be much nicer.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

