Return-Path: <linux-kernel-owner+w=401wt.eu-S934615AbYAaWrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615AbYAaWrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762366AbYAaWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:46:57 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:55057 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762112AbYAaWq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:46:56 -0500
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Frederik Himpe <fhimpe@telenet.be>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200801281246.24043.nickpiggin@yahoo.com.au>
References: <1200949086.6648.19.camel@Anastacia>
	 <200801221625.58615.nickpiggin@yahoo.com.au>
	 <1201354155.6853.4.camel@Anastacia>
	 <200801281246.24043.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Thu, 31 Jan 2008 23:45:59 +0100
Message-Id: <1201819559.2965.2.camel@Anastacia>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90-1mdv2008.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On ma, 2008-01-28 at 12:46 +1100, Nick Piggin wrote:
> On Sunday 27 January 2008 00:29, Frederik Himpe wrote:
> > On di, 2008-01-22 at 16:25 +1100, Nick Piggin wrote:
> > > > > On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > > > > > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > > > > > reader starts using 100% of CPU time after some time. When this
> > > > > > happens, kill -9 does not work, and strace just hangs when trying
> > > > > > to attach to the process. The same with gdb. ﻿ps shows the process
> > > > > > as being in the R state.

> Well after trying a lot of writev combinations, I've reproduced a hang
> *hangs head*.
> 
> Does this help?

Just to confirm: in four days of testing, I haven't seen the problem
anymore, so it looks like this was indeed the right fix.

Thanks!

-- 
Frederik Himpe <fhimpe@telenet.be>


