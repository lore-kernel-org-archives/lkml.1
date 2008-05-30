Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYE3Lst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYE3Lst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE3Lsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:48:41 -0400
Received: from serv26.loswebos.de ([213.187.93.214]:38173 "EHLO
	serv26.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYE3Lsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:48:39 -0400
X-Greylist: delayed 1852 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 07:48:38 EDT
X-Spam-Score: -3.977
Date: Fri, 30 May 2008 13:17:41 +0200
From: Wolf Wiegand <wolf.wiegand@web.de>
To: linux-kernel@vger.kernel.org
Subject: Oops in 2.6.25
Message-ID: <20080530111741.GB3533@denkbrett.wiegand.homedns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

(please CC me in replies)

my current kernel just threw an error, see output from ksymoops below.
I've been using this version for quite some time now, this is the first
time this has happened. There have been no hardware changes lately. The
hardware itself is nothing special, it's a somewhat dusty Thinkpad. 

I hope I have included all relevant information, please contact me if
more information is needed.

Cheers,

Wolf


ksymoops 2.4.11 on i686 2.6.25.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.25/ (default)
     -m /boot/System.map-2.6.25 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Pid: 7266, comm: convert Not tainted (2.6.25 #2)
EIP: 0060:[<c013bc09>] EFLAGS: 00210006 CPU: 0
Using defaults from ksymoops -t elf32-i386 -a i386
EAX: 00001000 EBX: 00001000 ECX: 00000000 EDX: 00000000
ESI: d2ce7bf8 EDI: d2ce7bfc EBP: 00002b4f ESP: d8c4beb0
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Stack: 02d60000 ffffffe5 d2ce7b04 00000000 c015161c d8c4bf34 00002b4f d2ce7b60
       01000003 d2ce7bf8 001200d2 00000000 02d60000 00000000 d8c4bf28 00002b4f
       c0151ef3 00000001 d8c4bf00 d2ce7b60 00000000 c0538bd0 b75ff004 d2cc03b0
Call Trace:
 [<c015161c>] shmem_getpage+0x58/0x852
 [<c0151ef3>] shmem_fault+0x79/0xa1
 [<c0145df3>] __do_fault+0x50/0x31b
 [<c0147a75>] handle_mm_fault+0x246/0x535
 [<c01125d5>] do_page_fault+0x205/0x520
 [<c01123d0>] do_page_fault+0x0/0x520
 [<c0427072>] error_code+0x6a/0x70
 [<c0420000>] e100_probe+0x495/0x5b6
Code: 5b 5b 5e 5f 5d c3 55 89 d5 57 56 89 c6 53 8d 78 04 fa b8 01 00 00 00 e8 6e 8b fd ff 89 ea 89 f8 e8 1d 35 10 00 85 c0 89 c3 74 59 <8b> 00 89 da 25 00 40 02 00 3d 00 40 02 00 75 03 8b 53 0c ff 42


>>EIP; c013bc09 <find_lock_page+25/a2>   <=====

Trace; c015161c <shmem_getpage+58/852>
Trace; c0151ef3 <shmem_fault+79/a1>
Trace; c0145df3 <__do_fault+50/31b>
Trace; c0147a75 <handle_mm_fault+246/535>
Trace; c01125d5 <do_page_fault+205/520>
Trace; c01123d0 <do_page_fault+0/520>
Trace; c0427072 <error_code+6a/70>
Trace; c0420000 <e100_probe+495/5b6>

ode;  c013bbde <pagecache_write_end+c3/c9>
00000000 <_EIP>:
Code;  c013bbde <pagecache_write_end+c3/c9>
   0:   5b                        pop    %ebx
Code;  c013bbdf <pagecache_write_end+c4/c9>
   1:   5b                        pop    %ebx
Code;  c013bbe0 <pagecache_write_end+c5/c9>
   2:   5e                        pop    %esi
Code;  c013bbe1 <pagecache_write_end+c6/c9>
   3:   5f                        pop    %edi
Code;  c013bbe2 <pagecache_write_end+c7/c9>
   4:   5d                        pop    %ebp
Code;  c013bbe3 <pagecache_write_end+c8/c9>
   5:   c3                        ret
Code;  c013bbe4 <find_lock_page+0/a2>
   6:   55                        push   %ebp
Code;  c013bbe5 <find_lock_page+1/a2>
   7:   89 d5                     mov    %edx,%ebp
Code;  c013bbe7 <find_lock_page+3/a2>
   9:   57                        push   %edi
Code;  c013bbe8 <find_lock_page+4/a2>
   a:   56                        push   %esi
Code;  c013bbe9 <find_lock_page+5/a2>
   b:   89 c6                     mov    %eax,%esi
Code;  c013bbeb <find_lock_page+7/a2>
   d:   53                        push   %ebx
Code;  c013bbec <find_lock_page+8/a2>
   e:   8d 78 04                  lea    0x4(%eax),%edi
Code;  c013bbef <find_lock_page+b/a2>
  11:   fa                        cli
Code;  c013bbf0 <find_lock_page+c/a2>
  12:   b8 01 00 00 00            mov    $0x1,%eax
Code;  c013bbf5 <find_lock_page+11/a2>
  17:   e8 6e 8b fd ff            call   fffd8b8a <_EIP+0xfffd8b8a>
Code;  c013bbfa <find_lock_page+16/a2>
  1c:   89 ea                     mov    %ebp,%edx
Code;  c013bbfc <find_lock_page+18/a2>
  1e:   89 f8                     mov    %edi,%eax
Code;  c013bbfe <find_lock_page+1a/a2>
  20:   e8 1d 35 10 00            call   103542 <_EIP+0x103542>
Code;  c013bc03 <find_lock_page+1f/a2>
  25:   85 c0                     test   %eax,%eax
Code;  c013bc05 <find_lock_page+21/a2>
  27:   89 c3                     mov    %eax,%ebx
Code;  c013bc07 <find_lock_page+23/a2>
  29:   74 59                     je     84 <_EIP+0x84>
Code;  c013bc09 <find_lock_page+25/a2>   <=====
  2b:   8b 00                     mov    (%eax),%eax   <=====
Code;  c013bc0b <find_lock_page+27/a2>
  2d:   89 da                     mov    %ebx,%edx
Code;  c013bc0d <find_lock_page+29/a2>
  2f:   25 00 40 02 00            and    $0x24000,%eax
Code;  c013bc12 <find_lock_page+2e/a2>
  34:   3d 00 40 02 00            cmp    $0x24000,%eax
Code;  c013bc17 <find_lock_page+33/a2>
  39:   75 03                     jne    3e <_EIP+0x3e>
Code;  c013bc19 <find_lock_page+35/a2>
  3b:   8b 53 0c                  mov    0xc(%ebx),%edx
Code;  c013bc1c <find_lock_page+38/a2>
  3e:   ff                        .byte 0xff
Code;  c013bc1d <find_lock_page+39/a2>
  3f:   42                        inc    %edx

EIP: [<c013bc09>] find_lock_page+0x25/0xa2 SS:ESP 0068:d8c4beb0
Warning (Oops_read): Code line not seen, dumping what data is available


>>EIP; c013bc09 <find_lock_page+25/a2>   <=====


2 warnings and 1 error issued.  Results may not be reliable.

-- 
Büroschimpfwort des Tages: Kontaktallergiker - meidet die Tratschrunden in der 
Kaffeeküche. (Sven-Lukas Müller)

--+QahgC5+KEYLbs62
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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
aFuHHEEH5oEOVQIAzc6WKmDIAAA=

--+QahgC5+KEYLbs62--
