Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYAOBgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYAOBgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYAOBf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:35:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34088 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYAOBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:35:58 -0500
Date: Tue, 15 Jan 2008 02:38:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080115013858.GA25112@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org> <20080115010534.GA24854@one.firstfloor.org> <478C0D18.5020505@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478C0D18.5020505@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 05:32:08PM -0800, Jeremy Fitzhardinge wrote:
> >
> >I just applied over the whole git-x86 patchkit (tip 
> >2f42671697ea9abc7d10ea7f663d6ef6e8ec6358)  + the two build fixes
> >Unfortunately it didn't work, although the faulting loop is shorter now:
> >  
> 
> Just to be clear, these two patches cause this oops to appear?  Current 

The two build fixes? Without that it just doesn't build.

> x86.git seems to be missing a pile of patches at the moment, so I 
> presume you're using a version which does have my patch set?

I just tested x86.git and then x86.git + patch you send (+ build fixes
in both cases), none of your patchkits. If you want me to test
some other patchkit please point me to it.

The problem happens with plain git-x86 (+ build fixes) and also
with git-x86 + your patch.

-Andi


