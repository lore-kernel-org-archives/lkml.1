Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZEREPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZEREPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 00:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZEREOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 00:14:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:44479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZEREOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 00:14:48 -0400
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely
 select CONFIG_FRAME_POINTER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1241565080.11379.14.camel@localhost.localdomain>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
	 <20090502001421.GA9342@oksana.dev.rtsoft.ru>
	 <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org>
	 <1241316249.4243.22.camel@localhost.localdomain>
	 <6A6BE346-925C-4F73-ABFA-C6110070F071@kernel.crashing.org>
	 <1241530382.11379.12.camel@localhost.localdomain>
	 <299D7402-29D3-4602-8F42-58FDF034DEC5@kernel.crashing.org>
	 <1241565080.11379.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 18 May 2009 14:14:04 +1000
Message-Id: <1242620044.18075.31.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 19:11 -0400, Steven Rostedt wrote:

> OK, so what's the status with this patch series?
> 
> I don't want to pull it in unless I have an ack from Sam, and now
> there's issues with having -fno-omit-frame-pointer. Should we add a
> patch instead that simply removes that?
> 
> If we eliminate the -fno-omit-frame-pointer, would that solve the PPC
> problem? And would it cause any other issues with other archs?

Well, the patch looks fine to me to be honest I'm not sure what the
complaint is above... 

IE. On arch that define the new HAVE_NORMAL_FRAME_POINTER (let's just
call it HAVE_IMPLIED_FRAME_POINTER then :-)  we just don't do
-fno-omit-frame-pointer and avoid triggering the bug...

Segher, what are we missing here ?

Ben.


