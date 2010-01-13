Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680Ab0AMXuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0AMXuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986Ab0AMXuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:50:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57602 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0AMXuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:50:14 -0500
Date: Thu, 14 Jan 2010 00:50:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #15041] Pagemap endless read loop with LTP
Message-ID: <20100113235010.GF24818@basil.fritz.box>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.tvF.tMlSLB@chimera> <2375c9f91001121904h2857760akbf2dd2c9f7441fc5@mail.gmail.com> <201001132257.34123.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001132257.34123.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:57:34PM +0100, Rafael J. Wysocki wrote:
> On Wednesday 13 January 2010, Américo Wang wrote:
> > On Mon, Jan 11, 2010 at 6:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15041
> > > Subject         : Pagemap endless read loop with LTP
> > > Submitter       : Andi Kleen <andi@firstfloor.org>
> > > Date            : 2010-01-10 2:09 (1 days old)
> > > References      : http://marc.info/?l=linux-kernel&m=126308941423848&w=4
> > >
> > 
> > According to Andi's later reply, it shoud not be an endless loop,
> > it just takes a rather long time.
> 
> Andi?

It'll try to read 47 bits worth of 0s on 64bit x86-64. 

I haven't tried to wait until that finishes, but I estimate a few months of 
CPU time at least.

The interface is just misdesigned, but I guess we cannot do
anything about that for now. LTP will just need to do a workaround.

This unfortunately breaks older LTP versions.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
