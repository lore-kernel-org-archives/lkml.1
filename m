Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0ATPYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0ATPYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696Ab0ATPYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:24:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46892 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0ATPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:24:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oh6Ol4xy7NR6XsSIsl19HyPeA7df9q7rWYDiYzSAZlETGyxDkDji+/Rw0RRrk1vGlx
         KSDsOC69iL1uoaMby4WdVyN+x0Pxdg8AWXPLghcgAz8WVpezB+Uk2SPUrDmqL6eKfmyb
         z568YxIzUfXoRBKZ8Es8ijP/tq2YSlDUe400Q=
Date: Wed, 20 Jan 2010 23:26:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       zhenchengjin@163.com
Subject: Re: nfs-error-RPC: multiple fragments per record not supported
Message-ID: <20100120152652.GA3595@hack>
References: <de04351e1001200320y2e763680gc7e3b20319c6386e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de04351e1001200320y2e763680gc7e3b20319c6386e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 07:20:34PM +0800, jin zhencheng wrote:
>I use kernel 2.6.26.2
>
>I use  29 clients,
>
>every client mount parameters as this: mount -t nfs -o
>rw,noatime,v3,rsize=32768,wsize=32768,hard,intr,tcp,nolock
>
>my system have many errors lke these :
>
>RPC: multiple fragments per record not supported
>RPC: multiple fragments per record not supported
>RPC: fragment too large: 0x318c87ee
>RPC: multiple fragments per record not supported
>RPC: fragment too large: 0x78bdeedb
>RPC: multiple fragments per record not supported
>RPC: fragment too large: 0x75cf8a33
>RPC: fragment too large: 0x44764ada
>RPC: multiple fragments per record not supported
>RPC: fragment too large: 0x0a08e7c0
>RPC: multiple fragments per record not supported
>RPC: multiple fragments per record not supported
>RPC: fragment too large: 0x5b4e13a1
>RPC: fragment too large: 0x08351a9f
>

Does 'ethtool -K eth0 tso off' help?

-- 
Live like a child, think like the god.
 
