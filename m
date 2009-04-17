Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZDQIRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZDQIRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZDQIRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:17:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:29622 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZDQIRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CXliKwIzfIDZM/HKk1YpPhe73Un+Re9NJeEBV3TGwIFo86wZUabZ4WMo04fTM/H1Jc
         LfX2/g1uHC7pXVuN9486G4/Ro2qaLGYs+38IQN49tc4LpQOcCw7UUwDKf0fqHz/3kmpi
         3sn1UI93LFbVWloysoa5h0KbrSxEKL/kr5/kk=
Date: Fri, 17 Apr 2009 16:18:23 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090417081823.GA31897@hack>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it> <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it> <20090329163228.GE7671@hack> <20090404101708.GG4203@cs.unibo.it> <20090407173646.GL12226@hack> <20090408121851.GE24173@cs.unibo.it> <20090413163603.GG2391@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090413163603.GG2391@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:36:03AM +0800, Américo Wang wrote:
>Anyway, I will test your patch tomorrow, and will send you more
>feedbacks soon.
>

Sorry for the delay.

I applied your 2 patches to linus-tree, compile and run, when I run
the same UML binary inside UML, I got:

Locating the bottom of the address space ... do_syscall_stub : ret =
-13, offset = 1052680, data = 0a98a008
do_syscall_stub: syscall 192 failed, return value = 0xfffffff3,
expected return value = 0x0
 syscall parameters: 0x0 0x1000 0x7 0x11 0x3 0x19c0
Failed to flush page for address 0x0
Killed

I don't have enough time to dig this, would like to have a look at it?

Thanks.

-- 
Live like a child, think like the god.
 
