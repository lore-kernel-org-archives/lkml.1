Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYJJROP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYJJROP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762041AbYJJRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:13:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38381 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761883AbYJJRNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:13:52 -0400
Date: Fri, 10 Oct 2008 12:13:50 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081010171350.GA28112@us.ibm.com>
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel> <48EF2BAB.1010009@fr.ibm.com> <20081010140430.GA14640@us.ibm.com> <1223657132.10017.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223657132.10017.42.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg Kurz (gkurz@fr.ibm.com):
> On Fri, 2008-10-10 at 09:04 -0500, Serge E. Hallyn wrote:
> > Remember a part of Ingo's motivation is to push c/r developers to
> > address the lacking features that users use most, earlier.  So the
> > warnings and subsequent email complaints are what we're after.  Hence a
> > single 'checkpointable or not' flag.
> > 
> > Given the single flag, how do you know at sys_mq_unlink() whether the
> > process also has an opensocket?
> > 
> > Rather than make this tracking facility more complicated and intrusive,
> > if people complain that they couldn't checkpoint bc of a warning about
> > aio, then we implement aio c/r!  We don't just try and reduce the amount
> > of time that you can't checkpoint bc of lack of aio c/r support  :)
> > 
> > -serge
> 
> Serge,
> 
> It's exactly what I meant before, the tracking facility would be awfully
> complicated. It cannot be done that way.
> But there's also something awkward with the flag thing : can you provide
> right now an exhaustive list of all the places where you must raise it ?
> 
> I'd rather do some heavy checking at checkpoint time.

Noone is saying that we are not going to do that.

-serge
