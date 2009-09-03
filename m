Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbZICFqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbZICFqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZICFqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:46:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57687 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbZICFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ntvl6jPEf4siJsBobA23FE97fTaVSZaewu0173xhJRhrDk3khCHJ6BK+iinutC4lp0
         5nIa/zHEAGuXxGpWceRL393WWoCSpbuTCuvsAGZWlZbPTe+hDVf6lWkWwta1M/xHzjzf
         z3OADq4phkYzv66enGlrfvQSlM1f+64t8SXE8=
Date: Thu, 3 Sep 2009 07:46:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add
	__kprobes to in-kernel fault handing functions
Message-ID: <20090903054633.GE6072@nowhere>
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain> <20090830005355.GB387@nowhere> <4A99E8CB.1040600@redhat.com> <20090830160939.GA6131@nowhere> <4A9E6BDD.6090705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A9E6BDD.6090705@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 08:58:05AM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > BTW, after your patchset:
> > 
> > TEST    posttest
> >   Building modules, stage 2.
> > Error: c0101038:	2e a1 f8 b0 9e c0    	mov    %cs:0xc09eb0f8,%eax
> > Error: objdump says 6 bytes, but insn_get_length() says 10 (attr:40000)
> > make[1]: *** [posttest] Erreur 2
> > make: *** [bzImage] Erreur 2
> > make: *** Attente des tâches non terminées....
> >   MODPOST 4 modules
> > 
> > 
> > I'm cross compiling from 64 to 32 using:
> > 
> > make ARCH=x86
> > 
> > I've attached my config.
> 
> Aah, you might miss an important patch :D
> http://lkml.org/lkml/2009/8/28/367
> 
> Thank you,


I thought I applied it.
I'm really an idiot :-(

Sorry for the noise.


 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

