Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZDKSdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZDKSdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZDKSc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:32:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:45957 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZDKScz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fZSqk+cCWxbjuBwSld2UsxmBNhmDU2AtneFx0DMeIK+EaEZDgaVtYNg9f/nOSevooP
         HAsWVtplcdz4Oe+1MX30dXyV7tavDwOMpRZNhPbXIWSq4pGJbvqvLMXylokLhDnYG+DG
         5yah9+HcnK6zfcboBdUzFELuAEwkN9wns9bJY=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: iptables very slow after commit 784544739a25c30637397ace5489eeb6e15d7d49
Date: Sat, 11 Apr 2009 20:32:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1; KDE/4.2.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, jengelh@medozas.de,
       paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, shemminger@vyatta.com,
       jeff.chua.linux@gmail.com, dada1@cosmosbay.com, kaber@trash.net,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <alpine.LFD.2.00.0904101828490.4583@localhost.localdomain> <20090410.230016.176733137.davem@davemloft.net> <f73f7ab80904111112n7c95d06ei32eb1f081842ae41@mail.gmail.com>
In-Reply-To: <f73f7ab80904111112n7c95d06ei32eb1f081842ae41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904112032.49335.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 of April 2009, Kyle Moffett wrote:

> Almost all of the standard firewall tools (such as shorewall, etc) are
> already using iptables-restore command to load firewall rules,
> primarily because using separate iptables commands was *already* way
> too slow.  

Some time ago there was batch patch that allowed to use standard shell format 
of calling iptables but did everything at once:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-
September/016704.html

It didn't get merged - no idea why.

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

