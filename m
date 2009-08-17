Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZHQODT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZHQODT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZHQODS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:03:18 -0400
Received: from stinky.trash.net ([213.144.137.162]:64935 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZHQODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:03:17 -0400
Message-ID: <4A896324.3040104@trash.net>
Date: Mon, 17 Aug 2009 16:03:16 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: System freeze on reboot - general protection fault
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>	 <alpine.DEB.1.10.0908111032110.30494@gentwo.org>	 <c4e36d110908110752x253e30epb00cc71f4683052b@mail.gmail.com>	 <alpine.DEB.1.10.0908111056550.30494@gentwo.org>	 <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>	 <20090811154853.GF2763@sgi.com>	 <c4e36d110908111410y29b922ceod6871fda2514f6e6@mail.gmail.com>	 <c4e36d110908121516u504809e9y537e9babfa95df1d@mail.gmail.com>	 <alpine.DEB.1.10.0908121820410.3257@gentwo.org>	 <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com> <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com> <4A87CE60.4020506@gmail.com>
In-Reply-To: <4A87CE60.4020506@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Zdenek Kabelac a écrit :
>>  [<ffffffffa02c502f>] nf_conntrack_ftp_fini+0x2f/0x70 [nf_conntrack_ftp]
>>  [<ffffffff8027bcc5>] sys_delete_module+0x1a5/0x270
>>  [<ffffffff8020d329>] ? retint_swapgs+0xe/0x13
>>  [<ffffffff80271bf2>] ? trace_hardirqs_on_caller+0x162/0x1b0
>>  [<ffffffff80292121>] ? audit_syscall_entry+0x191/0x1c0
>>  [<ffffffff80526dae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>  [<ffffffff8020c84b>] system_call_fastpath+0x16/0x1b
>> Code: c6 00 00 0f 82 66 ff ff ff 49 8b 9e d8 05 00 00 48 85 db 75 16
>> e9 8e 00 00 00 0f 1f 44 00 00 48 85 c0 0f 84 80 00 00 00 48 89 c3 <0f>
>> b6 4b 37 48 8b 03 48 8d 14 cd 00 00 00 00 0f 18 08 48 29 ca
>> RIP  [<ffffffffa02b2c2c>] nf_conntrack_helper_unregister+0x16c/0x320
>> [nf_conntrack]
>>  RSP <ffff88013982fe68>
>> CR2: 0000000000000038
>> ---[ end trace bc3a0ede3d0084db ]---
>>
> I am currently traveling and wont be able to help you before next week.
> 
> I added netdev, Patrick, and netfilter-devel in CC so that more eyes can take a look.

Thanks for the report, I'll have a look at this. Zdenek, please
send me the nf_conntrack.ko file used in the above oops. Thanks.
