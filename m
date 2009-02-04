Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZBDPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZBDPTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZBDPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:19:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:38182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZBDPTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:19:12 -0500
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4989A60E.9000809@redhat.com>
References: <1232287474.3130.19.camel@localhost.localdomain>
	 <20090118185635.GA30514@elte.hu> <497445B6.7030606@redhat.com>
	 <20090119110153.GA8321@uranus.ravnborg.org>	 <497469AC.2030107@redhat.com>
	 <3f9a31f40901232216r4656776mfac4388485180a60@mail.gmail.com>
	 <4989A60E.9000809@redhat.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 20:47:58 +0530
Message-Id: <1233760678.3180.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 16:28 +0200, Avi Kivity wrote:
> Jaswinder Singh Rajput wrote:
> >
> > latest -tip is still giving 'make headers_check' warnings:
> >  usr/include/linux/kvm.h:61: leaks CONFIG_X86 to userspace where it is not valid
> >  usr/include/linux/kvm.h:64: leaks CONFIG_X86 to userspace where it is not valid
> >  usr/include/linux/kvm.h:387: leaks CONFIG_X86 to userspace where it
> > is not valid
> >  usr/include/linux/kvm.h:391: leaks CONFIG_X86 to userspace where it
> > is not valid
> >  usr/include/linux/kvm.h:396: leaks CONFIG_X86 to userspace where it
> > is not valid
> >
> > So should I resend my patch or you are going to move this stuff
> >   
> 
> Your patch is broken.  I'll push mine shortly.
> 

hmm. it seems you are looking at old patches which we already dropped.

Please check the latest patches and kbuild at:
http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=shortlog;h=core/header-fixes

--
JSR

