Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbYLJUUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbYLJUUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYLJUT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:19:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbYLJUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:19:58 -0500
Date: Wed, 10 Dec 2008 15:19:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
In-Reply-To: <20081210200242.GA15692@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0812101515400.11805@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Dec 2008, Sam Ravnborg wrote:

> On Wed, Dec 10, 2008 at 02:48:35PM -0500, Steven Rostedt wrote:
> 
> Looking a bit deeper into this.
> I see that we have in Makefile.build:
> 
> define rule_cc_o_c
>         $(call echo-cmd,checksrc) $(cmd_checksrc)                         \
>         $(call echo-cmd,cc_o_c) $(cmd_cc_o_c);                            \
>         $(cmd_modversions)                                                \
>         $(cmd_record_mcount)   
> 
> So you want everyting to be rebuild if the command above changes.
> That should be doable - and it is indeed a bug that we do not do so.
> The integration of record_mcount needs to be improved.

Yes, that is exactly what I want. Now the next step is to implement this. 
I'm not that strong on the kbuild system to know how.

Thanks,

-- Steve

