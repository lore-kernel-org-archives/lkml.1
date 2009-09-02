Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZIBM4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZIBM4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZIBM4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZIBM4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:56:30 -0400
Message-ID: <4A9E6BDD.6090705@redhat.com>
Date: Wed, 02 Sep 2009 08:58:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add	__kprobes
 to in-kernel fault handing functions
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain> <20090830005355.GB387@nowhere> <4A99E8CB.1040600@redhat.com> <20090830160939.GA6131@nowhere>
In-Reply-To: <20090830160939.GA6131@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> BTW, after your patchset:
> 
> TEST    posttest
>   Building modules, stage 2.
> Error: c0101038:	2e a1 f8 b0 9e c0    	mov    %cs:0xc09eb0f8,%eax
> Error: objdump says 6 bytes, but insn_get_length() says 10 (attr:40000)
> make[1]: *** [posttest] Erreur 2
> make: *** [bzImage] Erreur 2
> make: *** Attente des tâches non terminées....
>   MODPOST 4 modules
> 
> 
> I'm cross compiling from 64 to 32 using:
> 
> make ARCH=x86
> 
> I've attached my config.

Aah, you might miss an important patch :D
http://lkml.org/lkml/2009/8/28/367

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

