Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZDBOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZDBOtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbZDBOth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:49:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:26310 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760533AbZDBOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:49:36 -0400
Message-ID: <49D4D075.9010702@codemonkey.ws>
Date: Thu, 02 Apr 2009 09:49:25 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090331184057.28333.77287.stgit@dev.haskins.net> <87ab71monw.fsf@basil.nowhere.org> <49D35825.3050001@novell.com> <20090401132340.GT11935@one.firstfloor.org> <49D37805.1060301@novell.com> <20090401170103.GU11935@one.firstfloor.org> <49D3B64F.6070703@codemonkey.ws> <49D3D7EE.4080202@novell.com> <49D46089.5040204@redhat.com> <49D497A1.4090900@novell.com> <49D4A4EB.8020105@redhat.com> <49D4AE0C.3000604@novell.com> <49D4B2C0.5060906@redhat.com> <49D4B594.6080703@novell.com> <49D4B8B4.4020003@redhat.com> <49D4BF70.1060301@novell.com> <49D4C191.2070502@redhat.com> <49D4CAA7.3020004@novell.com> <49D4CC61.6010105@redhat.com> <49D4CEB1.9020001@redhat.com>
In-Reply-To: <49D4CEB1.9020001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Avi Kivity wrote:
>>
>> The alternative is to get a notification from the stack that the 
>> packet is done processing.  Either an skb destructor in the kernel, 
>> or my new API that everyone is not rushing out to implement.
>
> btw, my new api is
>
>
>   io_submit(..., nr, ...): submit nr packets
>   io_getevents(): complete nr packets

I don't think we even need that to end this debate.  I'm convinced we 
have a bug somewhere.  Even disabling TX mitigation, I see a ping 
latency of around 300ns whereas it's only 50ns on the host.  This defies 
logic so I'm now looking to isolate why that is.

Regards,

Anthony Liguori

