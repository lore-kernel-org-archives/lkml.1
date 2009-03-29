Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZC2Qb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZC2Qb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZC2Qbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:31:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:49877 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZC2Qbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aNlKAzZKnmoVfrD/e4xabydW/qwD+sI4oOaEIvfUhZPUsD24Z268SAvoZLXlx4x6JN
         IRe3KD70JbIWlfb6cGhY3NEXiob8YgWjR7JkGXjuDjwUULRANoA7k8rMO5MMswqqSkQn
         SHOodPwVixPj903L4gowpCj4p2rjeUcUYUuik=
Date: Mon, 30 Mar 2009 00:32:28 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090329163228.GE7671@hack>
References: <20090204080236.GA17452@cs.unibo.it> <20090310214436.GC5213@cs.unibo.it> <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324234753.GH22695@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 12:47:53AM +0100, Renzo Davoli wrote:
>> Why not introduce a new request for PTRACE_VM but use *tags* in 'addr'?
>> We are taking risks of breaking the existing code. :)
>
>Yes, there is a minimal risk to break some code. This is a con.
>On the other side there are two main pros for this proposal:
>1- the code is now extremely simple 

Why adding a new request for ptrace is harder? I don't think so. :)


>2- if we define a different tag for syscall (e.g. PTRACE_VM), we need also
>different tags for PTRACE_VM_SINGLESTEP, PTRACE_VM_SINGLEBLOCK and maybe
>others in the future.
>Using the addr field we don't need this multiplication of tags
>(and we could soon delete PTRACE_SYSEMU and PTRACE_SYSEMU_SINGLESTEP).
>

Yes? We could also remove PTRACE_SYSEMU* if we had PTRACE_VM to replace
it. I would like to hear more from you on this point.

Thanks.

-- 
Do what you love, f**k the rest! F**k the regulations!
 
