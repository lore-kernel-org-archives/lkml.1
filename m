Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZGUQtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZGUQtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZGUQtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:49:12 -0400
Received: from mail.candelatech.com ([208.74.158.172]:37899 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZGUQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:49:12 -0400
Message-ID: <4A65F184.5060802@candelatech.com>
Date: Tue, 21 Jul 2009 09:49:08 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
Subject: Re: Error mounting FC8 NFS server with 2.6.31-rc3 NFSv4 client.
References: <4A64EB1F.4000602@candelatech.com> <1248178527.5222.0.camel@heimdal.trondhjem.org>
In-Reply-To: <1248178527.5222.0.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 05:15 AM, Trond Myklebust wrote:

>
> What does /var/lib/nfs/v4recovery look like on the server?

The server was misconfigured, but I still think the client should
behave better in this case.  If you cannot reproduce it, let me know
and I can try to be more specific.  If you still want the v4recovery
information, let me know and I'll send it.


I had my /etc/exports looking like this on the file-server:

/export/tmp 192.168.100.0/24(rw)


When I changed it to be:
/export/tmp 192.168.100.0/24(rw,fsid=0)


And mounted 192.168.100.6:/ instead of 192.168.100.6:/export/tmp
then it mounts properly and appears to work just fine.

If I leave file-server configured properly with fsid=0, but try
to mount 192.168.100.6:/export/tmp then I get an error about
no such file or directory, which also appears to be correct
behaviour.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

