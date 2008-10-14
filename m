Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYJNODr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYJNODr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYJNODk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:03:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35279 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYJNODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:03:39 -0400
Date: Tue, 14 Oct 2008 16:10:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oprofile kernel git tree
Message-ID: <20081014141022.GP12131@one.firstfloor.org>
References: <20081013202022.GE23557@erda.amd.com> <87r66kqlpt.fsf@basil.nowhere.org> <20081014135645.GF23557@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014135645.GF23557@erda.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 03:56:45PM +0200, Robert Richter wrote:
> On 13.10.08 22:33:18, Andi Kleen wrote:
> > Robert Richter <robert.richter@amd.com> writes:
> > >
> > > Feature branches (patches not yet ready for upstream, fast-forward only):
> > >
> > >  arch-perfmon
> > 
> > What do you mean with that? arch-perfmon is definitely ready for upstream.
> 
> This contains only the patch I wrote that changes the
> initialization. All other patches are already in the upstream branch.

I see. Thanks. The init change is unfortunately not correct.
Doing it this way would require quite a big restructuring
to call the init functions in the right order. Probably not
worth it to avoid one function call.

-Andi
