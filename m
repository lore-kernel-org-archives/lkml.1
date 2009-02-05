Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbZBEAg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbZBEAg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZBEAgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:36:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757230AbZBEAgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:36:40 -0500
Subject: Re: [PATCH 2/3] powerpc: Make it possible to safely select
	CONFIG_FRAME_POINTER
From: Steven Rostedt <srostedt@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1233793889.4612.33.camel@pasglop>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150838.GB30027@oksana.dev.rtsoft.ru>
	 <1233793889.4612.33.camel@pasglop>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 04 Feb 2009 19:35:54 -0500
Message-Id: <1233794154.16878.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-02-05 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-02-04 at 18:08 +0300, Anton Vorontsov wrote:
> > Remove -fno-omit-frame-pointer flag from CFLAGS.
> > Remove -fno-omit-frame-pointer workarounds.
> 
> But what about -pg -requires -fno-omit-frame-pointer ?

I don't think it requires -fno-omit-frame-pointer. It is just
incompatible with -fomit-frame-pointer.

-- Steve


