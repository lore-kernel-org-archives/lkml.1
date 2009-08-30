Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZH3Ax6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZH3Ax6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZH3Ax5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:53:57 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62532 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZH3Ax4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X7AyXTA058RgdPserx8HkW7DROY06FvRPI1xtLtM+/mv0POeSlCexF0yBQsA42FTka
         Y0CkRIFndEaqxX/vPyHQz1pSCywmCY2EVkKE1mN81XX0yEuhrxc+uFx4a7h8RnBg0neC
         Noj/yK+T6j0Gr7gkpXXLtNMuXlrrHbLQRLbZo=
Date: Sun, 30 Aug 2009 02:53:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip tracing/kprobes 3/6] kprobes/x86: Fix to add
	__kprobes to in-kernel fault handing functions
Message-ID: <20090830005355.GB387@nowhere>
References: <20090827152539.GE6058@nowhere> <20090827172311.8246.92725.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827172311.8246.92725.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:23:11PM -0400, Masami Hiramatsu wrote:
> Add __kprobes to the functions which handles in-kernel fixable page faults.
> Since kprobes can cause those in-kernel page faults by accessing kprobe data
> structures, probing those fault functions will cause fault-int3-loop
> (do_page_fault has already been marked as __kprobes).


BTW, is it possible to assert a struct kprobe (and its pointer members)
haven't been allocated through vmalloc() ?

