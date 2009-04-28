Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZD1Urf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZD1Urf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZD1UrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:47:11 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:57875 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZD1UrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:47:09 -0400
X-Greylist: delayed 9315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 16:47:08 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dVt4/1dnsnrIBZLXREQbccmuxuSzUqvj4lB0t/Niv70Q5ZnEK+JAb4DXPRn84LFwfw
         H8hhx/ffQUm/VVF2hGpG7QC0ac5j21AkcFey2zOrZLijX3yvkfV45DdnOC9MewvER8vB
         tC4Fr22YgDoAhZ9LQ2RZZ/MJ8RG7jvWXzRrBM=
MIME-Version: 1.0
In-Reply-To: <1240943671.938.575.camel@calx>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu>
	 <20090428083320.GB17038@localhost>
	 <12c511ca0904281111r10f37a5coe5a2750f4dbfbcda@mail.gmail.com>
	 <1240943671.938.575.camel@calx>
Date: Tue, 28 Apr 2009 13:47:07 -0700
Message-ID: <12c511ca0904281347m394b04e0mcb61f7c336752cc4@mail.gmail.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Tony Luck <tony.luck@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 11:34 AM, Matt Mackall <mpm@selenic.com> wrote:
> Bah. The rate of change is proportional to #cpus, not #pages. Assuming
> you've got 1024 processors, you could run the scan in parallel in .2
> seconds still.

That would help ... it would also make the patch to support this
functionality a lot more complex.

-Tony
