Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZGUSCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZGUSCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZGUSCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:02:03 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55301 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZGUSCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:02:02 -0400
Message-ID: <4A660295.9020807@candelatech.com>
Date: Tue, 21 Jul 2009 11:01:57 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
References: <4A64EB1F.4000602@candelatech.com>	 <1248178527.5222.0.camel@heimdal.trondhjem.org>	 <4A65F184.5060802@candelatech.com>	 <1248196339.21343.8.camel@heimdal.trondhjem.org>	 <4A65FCB2.6080903@candelatech.com> <1248199140.21343.17.camel@heimdal.trondhjem.org>
In-Reply-To: <1248199140.21343.17.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 10:59 AM, Trond Myklebust wrote:
> On Tue, 2009-07-21 at 10:36 -0700, Ben Greear wrote:
>> On 07/21/2009 10:12 AM, Trond Myklebust wrote:
>>> On Tue, 2009-07-21 at 09:49 -0700, Ben Greear wrote:
>>>> On 07/21/2009 05:15 AM, Trond Myklebust wrote:
>>>>
>>>>> What does /var/lib/nfs/v4recovery look like on the server?
>>>> The server was misconfigured, but I still think the client should
>>>> behave better in this case.  If you cannot reproduce it, let me know
>>>> and I can try to be more specific.  If you still want the v4recovery
>>>> information, let me know and I'll send it.
>>> So how should the client behave, when a screwed up server allows it to
>>> mount but starts returning illegal values for setclientid? The only
>>> thing I can see we could do is to tell the user EINSANESERVER...
>> Well, it could just fail the mount and give up and not overly spam
>> /var/log/messages in a tight loop perhaps?
>
> This doesn't happen at mount time. It happens when you open a file.

Not for me, and evidently not for the other person that reported
similar results.  All I had to do was attempt the mount (which never
completed).

Thanks,
Ben

>
> Trond


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

