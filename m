Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbZBEBTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbZBEBTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759639AbZBEBTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:19:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:48957 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759141AbZBEBTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:19:15 -0500
Subject: Re: [PATCH 2/3] powerpc: Make it possible to safely select
 CONFIG_FRAME_POINTER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1233794154.16878.20.camel@localhost.localdomain>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150838.GB30027@oksana.dev.rtsoft.ru>
	 <1233793889.4612.33.camel@pasglop>
	 <1233794154.16878.20.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 12:15:31 +1100
Message-Id: <1233796531.4612.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 19:35 -0500, Steven Rostedt wrote:
> On Thu, 2009-02-05 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2009-02-04 at 18:08 +0300, Anton Vorontsov wrote:
> > > Remove -fno-omit-frame-pointer flag from CFLAGS.
> > > Remove -fno-omit-frame-pointer workarounds.
> > 
> > But what about -pg -requires -fno-omit-frame-pointer ?
> 
> I don't think it requires -fno-omit-frame-pointer. It is just
> incompatible with -fomit-frame-pointer.

>From a quick test, you seem to be right.

Now the question of course is whether -pg will internally trigger
the bug for which we need the workaround tho...

Ben.

