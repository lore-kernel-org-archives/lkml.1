Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZDODNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZDODNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZDODNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:13:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44507 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZDODNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:13:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] vsprintf: introduce %pf
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Frysinger <vapier.adi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904142238060.31421@gandalf.stny.rr.com>
References: <8bd0f97a0904141917g3496f526ifc4fe0bd41c3d1c7@mail.gmail.com> <alpine.DEB.2.00.0904142238060.31421@gandalf.stny.rr.com>
Message-Id: <20090415121026.AC37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 15 Apr 2009 12:13:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, 14 Apr 2009, Mike Frysinger wrote:
> 
> > On Tue, Apr 14, 2009 at 20:00, Frederic Weisbecker wrote:
> > > - * - 'F' For symbolic function descriptor pointers
> > > + * - 'F' For symbolic function descriptor pointers with asm offset
> > > + * - 'f' For simple function symbol
> > 
> > "asm" is weird here as it isnt an assembly offset (not that i have any
> > idea what an "assembly offset" even means).  just say "offset".
> 
> Or perhaps better: function offset, as it ususally means the offset into 
> the function.

maybe No. 

if %pf point to global function, offset is meaningless
(only have internal meaning)
it point to static function, offset mean offset against previous symbol.

perhaps, the symbol can non function symbol...



