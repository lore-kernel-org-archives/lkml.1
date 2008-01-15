Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYAOQuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYAOQuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYAOQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:50:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50442 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYAOQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:50:40 -0500
Date: Tue, 15 Jan 2008 17:53:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080115165342.GA1824@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115010534.GA24854@one.firstfloor.org> <20080115125556.GA3475@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115125556.GA3475@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 01:55:56PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I just applied over the whole git-x86 patchkit (tip 
> > 2f42671697ea9abc7d10ea7f663d6ef6e8ec6358) + the two build fixes 
> > Unfortunately it didn't work, although the faulting loop is shorter 
> > now:
> > 
> > Freeing unused kernel memory: 260k freed
> > mount[1159]: segfault at b7fcfe98 ip b7ec6b7a sp bfcfcdec error 7
> > Eeek! page_mapcount(page) went negative! (-1)
> 
> could you please send me the .config you are using on that kernel?

http://halobates.de/config32

Essentially defconfig with CONFIG_IDE disabled and PAE enabled

-Andi
