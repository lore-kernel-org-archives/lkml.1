Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZDOCis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZDOCis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZDOCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:38:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZDOCii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:38:38 -0400
Date: Tue, 14 Apr 2009 22:38:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: introduce %pf
In-Reply-To: <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904142238060.31421@gandalf.stny.rr.com>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Mike Frysinger wrote:

> On Tue, Apr 14, 2009 at 20:00, Frederic Weisbecker wrote:
> > - * - 'F' For symbolic function descriptor pointers
> > + * - 'F' For symbolic function descriptor pointers with asm offset
> > + * - 'f' For simple function symbol
> 
> "asm" is weird here as it isnt an assembly offset (not that i have any
> idea what an "assembly offset" even means).  just say "offset".

Or perhaps better: function offset, as it ususally means the offset into 
the function.

-- Steve

