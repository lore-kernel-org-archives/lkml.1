Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbYFDOAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbYFDOAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYFDOAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:00:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:62972 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYFDOAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s/ZroZmnW3ojcJgM2pylFK4533K15ICe/Yw7CuwpurqaQgLB/auPX6GbeIL739W4rc
         rGs75MdS5VegwwBd4bivcxPCPTJqsiu0bEJGG07hgxrd6cITm+zszPdGdPFGOCzPSudV
         R5nf5Tp2CIlopbRvqyB8YI5SoXXnX5QyUK2uk=
Message-ID: <a01a16b50806040700h1efce63cq2a27b087df0d25be@mail.gmail.com>
Date: Wed, 4 Jun 2008 16:00:29 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806041402211.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu> <1211966834.12349.62.camel@twins>
	 <a01a16b50805310725x4f1c375ep2d091bb044ac0787@mail.gmail.com>
	 <Pine.LNX.4.64.0805311839540.2657@wrl-59.cs.helsinki.fi>
	 <484191BD.8000904@gmail.com>
	 <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
	 <a01a16b50805311325w7f58ca69h93d02af9bc28d2ea@mail.gmail.com>
	 <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
	 <a01a16b50806031710u54b9297bkf1fad9c4f8fd581f@mail.gmail.com>
	 <Pine.LNX.4.64.0806041402211.16829@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m54E0rHl002658

2008/6/4 Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>:> On Wed, 4 Jun 2008, HÃ¥kon LÃ¸vdal wrote:>>> Hi. I have now tested and taken various logs before/under/after (ps,>> netstat, tcpdump, strace, /proc/net/tcp). The logs did not grow as big>> as I feared however they are way too big attach here. Any tips on how to>> distribute?>> Usually such logs compress quite well. A best thing might be to put> somewhere (if possible) and http:// reference them.
The largest file was a strace log of 1.5GB uncompressed. I will try tosort out something.

>> //netstat before the hang:>> Proto Recv-Q Send-Q Local Address               Foreign Address>>      State       PID/Program name    Timer>> tcp        0    504 new_pc:22                   old_pc:39464>>      ESTABLISHED 17054/sshd: hlovdal on (0.20/0/0)>>>> // after the hang:>> Proto Recv-Q Send-Q Local Address               Foreign Address>>      State       PID/Program name    Timer>> tcp        0   2896 old_pc:22                   new_pc:39464>>      ESTABLISHED -                   on (21329441.19/0/0)>> ??? Are these on the same machine? How come the ip-addresses got reversed> (while ports remain the same)...?!?
Oops, that was an editing mistake on my part, old and new are mixed upin the last line.
BR HÃ¥kon LÃ¸vdalÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
