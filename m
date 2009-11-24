Return-Path: <linux-kernel-owner+w=401wt.eu-S933180AbZKXOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbZKXOwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbZKXOwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:52:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49431 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbZKXOwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:52:36 -0500
Subject: Re: cannot compile linux-2.6-tip tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 09:52:41 -0500
Message-Id: <1259074361.22249.1069.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 13:41 +0100, Jiri Olsa wrote:

> [jolsa@jolsa linux-2.6-tip]$ git checkout -b test-bad 2e7c0e0cafee5f04a029f06e71e22f9af69ae472
> Switched to a new branch 'test-bad'
> [jolsa@jolsa linux-2.6-tip]$ find drivers/pnp/ -name *.o | xargs rm
> [jolsa@jolsa linux-2.6-tip]$ make drivers/pnp/
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/asm/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/pnp/core.o
>   CC      drivers/pnp/card.o
> objdump: drivers/pnp/.tmp_card.o: File truncated
> nm: drivers/pnp/card.o: File truncated
> objdump: drivers/pnp/card.o: File truncated


That's a strange error. Are you sure you didn't run out of diskspace or
something?

-- Steve

>   CC      drivers/pnp/driver.o
>   CC      drivers/pnp/resource.o
>   CC      drivers/pnp/manager.o
>   CC      drivers/pnp/support.o
>   CC      drivers/pnp/interface.o
>   CC      drivers/pnp/quirks.o
>   CC      drivers/pnp/pnpacpi/core.o
>   CC      drivers/pnp/pnpacpi/rsparser.o
>   LD      drivers/pnp/pnpacpi/built-in.o
>   CC      drivers/pnp/system.o
>   LD      drivers/pnp/built-in.o
> drivers/pnp/card.o: file not recognized: File format not recognized
> make[1]: *** [drivers/pnp/built-in.o] Error 1
> make: *** [drivers/pnp/] Error 2
> [jolsa@jolsa linux-2.6-tip]$ 
> 


