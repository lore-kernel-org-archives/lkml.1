Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYGXDpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYGXDpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYGXDpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:45:05 -0400
Received: from ozlabs.org ([203.10.76.45]:46478 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYGXDpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:45:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: kernel/trace/ftrace.c new warning in next-20080723
Date: Thu, 24 Jul 2008 10:52:11 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-next <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1216852786.30386.30.camel@brick>
In-Reply-To: <1216852786.30386.30.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807241052.12177.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 08:39:45 Harvey Harrison wrote:
> > kernel/trace/ftrace.c: In function ‘ftrace_run_update_code’:
> > kernel/trace/ftrace.c:590: warning: ‘stop_machine_run’ is deprecated
> > (declared at include/linux/stop_machine.h:59) kernel/trace/ftrace.c: In
> > function ‘ftrace_update_code’:
> > kernel/trace/ftrace.c:790: warning: ‘stop_machine_run’ is deprecated
> > (declared at include/linux/stop_machine.h:59) kernel/trace/ftrace.c: In
> > function ‘ftrace_dynamic_init’:
> > kernel/trace/ftrace.c:1567: warning: ‘stop_machine_run’ is deprecated
> > (declared at include/linux/stop_machine.h:59)
>
> FYI,
>
> Harvey

Yep, this is known, expected and harmless.  I'm waiting for Linus to pull my 
lguest and virtio patches before I send the stop_machine changes.

Cheers,
Rusty.
