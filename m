Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbZGPQhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbZGPQhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932757AbZGPQhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:37:11 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33339 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbZGPQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:37:10 -0400
Date: Thu, 16 Jul 2009 18:37:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 01/11] x86: instruction decoder API
Message-ID: <20090716163708.GB5804@merkur.ravnborg.org>
Mail-Followup-To: Masami Hiramatsu <mhiramat@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
	DLE <dle-develop@lists.sourceforge.net>,
	Jim Keniston <jkenisto@us.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Avi Kivity <avi@redhat.com>,
	Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155700.6266.71011.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716155700.6266.71011.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
> new file mode 100644
> index 0000000..01e079a
> --- /dev/null
> +++ b/arch/x86/include/asm/inat.h
> @@ -0,0 +1,125 @@
> +#ifndef _ASM_INAT_INAT_H
> +#define _ASM_INAT_INAT_H

[With reference to comment on patch 2/12...]
You create inat.h here.
Could you investigave what is needed to factor out the stuff
needed from userspace so we can avoid the ugly havk where
you redefine types.h?

Maybe create a inat_types.h + inat.h as we do in other cases?

Same for the other files that requred the types.h hack.

	Sam

