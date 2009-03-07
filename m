Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZCGVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZCGVqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 16:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZCGVqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 16:46:45 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18729 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbZCGVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 16:46:44 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PACH][RFC] SMACK : add  logging support V1
Date: Sat, 7 Mar 2009 16:46:40 -0500
User-Agent: KMail/1.11.1 (Linux/2.6.27-gentoo-r8; KDE/4.2.1; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       LSM <linux-security-module@vger.kernel.org>,
       Dmitriy Romashkin <dmitriy.romashkin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49B27134.2020103@numericable.fr>
In-Reply-To: <49B27134.2020103@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071646.40839.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 March 2009 08:05:56 am etienne wrote:
> Hello,
>
> the following patch, against current 2.6.29-rc7, add logging of smack
> decisions. This is of course very useful to understand what your current
> smack policy does. It borrows a lot from selinux;
>
> It introduces a '/smack/logging' switch :
> 0: no logging
> 1: log denied (default)
> 2: log accepted
> 3: log denied&accepted
>
>
> example of logs produced :
>
> type=1400 audit(1236429348.858:5655879): SMACK[smack_task_kill]:  denied 
> pid=6521 comm="bash" subject:'toto' object:'_' requested:w pid=5757
> comm="knetworkmanager" type=1400 audit(1236429361.477:5655882):
> SMACK[smk_curacc_shm]:  denied  pid=6533 comm="ipcrm" subject:'toto'
> object:'_' requested:rw key=491521 type=1400 audit(1236429392.389:5655885):
> SMACK[smack_sb_mount]:  denied  pid=6536 comm="mount" subject:'toto'
> object:'_' requested:w  path="/debug" dev=sda5 ino=16161 type=1400
> audit(1236429485.009:5655890): SMACK[smack_ptrace_may_access]:  denied 
> pid=6539 comm="strace" subject:'toto' object:'_' requested:rw pid=5634
> comm="python" type=1400 audit(1236429527.693:5655893):
> SMACK[smack_inode_getattr]:  denied  pid=6544 comm="ls" subject:'toto'
> object:'etienne' requested:r  path="/home/etienne/linux" dev=sda8
> ino=2342913 type=1400 audit(1236429741.006:6006665):
> SMACK[smack_socket_sendmsg]:  granted  pid=6580 comm="ping" subject:'toto'
> object:'@' requested:w  daddr=192.168.0.10 type=1400
> audit(1236429741.006:6006666): SMACK[smack_socket_sock_rcv_skb]:  granted 
> pid=6580 comm="ping" subject:'@' object:'toto' requested:w 
> saddr=192.168.0.10 daddr=192.168.0.10 netif=lo

You will want to send this to the audit mailing list (linux-audit@redhat.com) 
for review, I suspect they will have several comments.

-- 
paul moore
linux @ hp

