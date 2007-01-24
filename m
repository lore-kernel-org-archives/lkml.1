Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXAXPee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXAXPee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXAXPed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:34:33 -0500
Received: from server077.de-nserver.de ([62.27.12.245]:33680 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXAXPec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:34:32 -0500
Message-ID: <45B77C84.6070508@profihost.com>
Date: Wed, 24 Jan 2007 16:34:28 +0100
From: Stefan Priebe - FH <studium@profihost.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org, stefan@priebe.ws,
       David Chinner <dgc@sgi.com>
Subject: Re: XFS or Kernel Problem / Bug
References: <20060801141545.B2326184@wobbly.melbourne.sgi.com> <44CED76B.20507@profihost.com> <20060801142755.C2326184@wobbly.melbourne.sgi.com> <44CED8F4.9080208@profihost.com> <20060801143212.D2326184@wobbly.melbourne.sgi.com> <44CEDA1D.5060607@profihost.com> <20060801143803.E2326184@wobbly.melbourne.sgi.com> <44CF36FB.6070606@profihost.com> <20060802090915.C2344877@wobbly.melbourne.sgi.com> <44D07AB7.3020409@profihost.com> <20060802201805.A2360409@wobbly.melbourne.sgi.com> <45B35CD7.4080801@profihost.com> <45B666BE.8000802@redhat.com> <45B70D69.20500@profihost.com> <45B773C1.7090805@redhat.com> <45B77547.4060302@profihost.com> <45B77780.5000504@redhat.com>
In-Reply-To: <45B77780.5000504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 84.134.53.198
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Sorry that is not possible - cause it is a production machine.

But i've catched the error and the files from another machine - perhaps 
this helps.

"BUG: unable to handle kernel NULL pointer dereference at virtual 
address 00000288"
" printing eip:"
"c0142ff7"
"*pde = 00000000"
"Oops: 0000 [#1]"
"SMP "
"Modules linked in: iptable_filter ip_tables x_tables"
"CPU:    0"
"EIP:    0060:[<c0142ff7>]    Not tainted VLI"
"EFLAGS: 00010246   (2.6.18.6 #1) "
"EIP is at generic_file_buffered_write+0x390/0x6cf"
"eax: 00000000   ebx: 000001ec   ecx: ea029a40   edx: 00008002"
"esi: 00000000   edi: e3b28c9c   ebp: 000001ec   esp: dd04bd18"
"ds: 007b   es: 007b   ss: 0068"
"Process proftpd (pid: 3615, ti=dd04a000 task=eba88a70 task.ti=dd04a000)"
"Stack: e3b28d44 00000001 00000010 000001fc c036d793 000001fc c14765c0 
00000010 "
"       080d404c 000001ec e3b28c9c c03e78c0 e3b28d44 ea029a40 000001fc 
00000000 "
"       00000000 000001ec dd04beac 00d420b1 00000000 00000000 dd04bd80 
45b1fa67 "
"Call Trace:"
" [<c036d793>] sock_def_readable+0x7f/0x81"
" [<c017a03a>] file_update_time+0xad/0xcb"
" [<c0232015>] xfs_iunlock+0x55/0x9f"
" [<c0262eeb>] xfs_write+0xa74/0xc61"
" [<c036a253>] sock_aio_read+0x95/0x99"
" [<c025d9fb>] xfs_file_aio_write+0x8f/0xa0"
" [<c015fb94>] do_sync_write+0xc9/0x10f"
" [<c0133ad6>] autoremove_wake_function+0x0/0x57"
" [<c015f3d5>] generic_file_llseek+0x95/0xbc"
" [<c015facb>] do_sync_write+0x0/0x10f"
" [<c015fc80>] vfs_write+0xa6/0x179"
" [<c015fe24>] sys_write+0x51/0x80"
" [<c0102d3f>] syscall_call+0x7/0xb"
"Code: 04 89 10 8b 44 24 40 85 c0 0f 85 db 00 00 00 8b 5c 24 24 85 db 0f 
88 c3 00 00 00 8b 4c 24 34 8b 51 18 f6 c6 10 75 73 8b 7c 24 28 <8b> 85 
9c 00 00 00 f6 40 30 10 75 63 f6 87 48 01 00 00 01 75 5a "
"EIP: [<c0142ff7>] generic_file_buffered_write+0x390/0x6cf SS:ESP 
0068:dd04bd18"

Files:
http://server113-han.de-nserver.de/filemap.s
http://server113-han.de-nserver.de/filemap.o

Stefan

Chuck Ebbert schrieb:
> Stefan Priebe - FH wrote:
>> It could be, that the options are now different - cause i my first try
>> was to change the kernel options - if that did not help i switched
>> back to 2.6.16.37.
>>
>> Any idea what i can do?
>>
>> Chuck Ebbert schrieb:
>>> That doesn't match your oops at all.  Did you use a different compiler
>>> and/or
>>> different kernel build options?
>>>
>>>
> If you don't know what changed you can try different options until the
> filemap.s
> is the same.  You should see
> 
>         movl   156(%ebp),%eax
>         testb   16, 48(%eax)
> 
> 
> in generic_file_buffered_write.  And you need to regenerate filemap.s
> manually
> each time.
> 
> 
> (Did you test the kernel that you posted these pieces from? If you can
> get it to oops
> the same way, just post that instead.)
> 

