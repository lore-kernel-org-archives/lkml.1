Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbYAVFDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbYAVFDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYAVFDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:03:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:60326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751406AbYAVFDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:03:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/EqS9hNAjEraMqQeA2moL791QoVBg54uLLqqFTqb
	Nua7CYcb9wt0bG
Subject: Re: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Mike Galbraith <efault@gmx.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Frederik Himpe <fhimpe@telenet.be>, linux-kernel@vger.kernel.org
In-Reply-To: <200801221105.11413.nickpiggin@yahoo.com.au>
References: <1200949086.6648.19.camel@Anastacia>
	 <200801221105.11413.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Date: Tue, 22 Jan 2008 06:03:27 +0100
Message-Id: <1200978207.3944.8.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 11:05 +1100, Nick Piggin wrote:
> On Tuesday 22 January 2008 07:58, Frederik Himpe wrote:
> > With Linux 2.6.24-rc8 I often have the problem that the pan usenet
> > reader starts using 100% of CPU time after some time. When this happens,
> > kill -9 does not work, and strace just hangs when trying to attach to
> > the process. The same with gdb. ﻿ps shows the process as being in the R
> > state.
> >
> > I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
> > Jan 21 21:45:01 Anastacia kernel: pan           R  running task        0 
> 
> Well I've twice tried to submit a patch to print stacks for running
> tasks as well, but nobody seems interested. It would at least give a
> chance to see something.

I've hit same twice recently (not pan, and not repeatable).

