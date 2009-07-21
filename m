Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZGUVvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZGUVvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZGUVvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:51:04 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50722 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbZGUVvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:51:03 -0400
Message-ID: <4A663842.7040607@candelatech.com>
Date: Tue, 21 Jul 2009 14:50:58 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
References: <4A64EB1F.4000602@candelatech.com>	 <1248178527.5222.0.camel@heimdal.trondhjem.org>	 <4A65F184.5060802@candelatech.com>	 <1248196339.21343.8.camel@heimdal.trondhjem.org>	 <4A65FCB2.6080903@candelatech.com>	 <1248199140.21343.17.camel@heimdal.trondhjem.org>	 <4A660295.9020807@candelatech.com>	 <1248200897.21343.19.camel@heimdal.trondhjem.org>	 <4A6609A9.3000504@candelatech.com>	 <1248211050.21343.38.camel@heimdal.trondhjem.org> <1248212939.5034.1.camel@heimdal.trondhjem.org>
In-Reply-To: <1248212939.5034.1.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 02:48 PM, Trond Myklebust wrote:

>> Note that there is a bug remaining inside nfs4_init_session(): we
>> shouldn't be copying the rsize/wsize into the nfs_client if the latter
>> was already initialised. I'm going to leave that for the moment, though,
>> since that bug wasn't introduced by my patch, and it doesn't affect
>> NFSv4.0.
>
> With that patch applied, I now get the expected behaviour when mounting
> a server with no NFSv4 root from a 2.6.31-rc3 based client:
>
> root@heimdal:~# mount -t nfs4 munkholm.local:/ /mnt
> mount.nfs4: mounting munkholm.local:/ failed, reason given by server:
>    No such file or directory
>
> Trond

I just successfully tested it on my systems as well, so I think this
does indeed fix the problem.

Thanks!
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

