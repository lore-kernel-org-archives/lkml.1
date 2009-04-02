Return-Path: <linux-kernel-owner+w=401wt.eu-S933488AbZDBQxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbZDBQxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbZDBQvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:51:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36326 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbZDBQvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:51:40 -0400
Message-ID: <49D4ED29.3000806@redhat.com>
Date: Thu, 02 Apr 2009 19:51:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Gregory Haskins <ghaskins@novell.com>,
       Patrick Mullaney <pmullaney@novell.com>, anthony@codemonkey.ws,
       andi@firstfloor.org, Peter Morreale <PMorreale@novell.com>,
       rusty@rustcorp.com.au, agraf@suse.de, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <49D469D2020000A100045FA1@lucius.provo.novell.com> <49D473EA020000C700056627@lucius.provo.novell.com> <49D473EA020000C700056627@lucius.provo.novell.com> <49D4CB38.5030205@redhat.com> <49D4DA54.3090401@novell.com> <49D4DE82.5020306@redhat.com> <20090402160625.GA2173@gondor.apana.org.au>
In-Reply-To: <20090402160625.GA2173@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, Apr 02, 2009 at 06:49:22PM +0300, Avi Kivity wrote:
>   
>> I still think you want one MSI per device rather than one MSI per vbus,  
>> to avoid scaling problems on large guest.  After Herbert's let loose on  
>> the code, one MSI per queue.
>>     
>
> Yes, one MSI per TX queue, and one per RX queue :)
>
>   

We're currently limited to 1024, so go wild :)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

