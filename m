Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277Ab0ASPpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0ASPpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254Ab0ASPo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:44:57 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49156 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab0ASPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:44:56 -0500
Date: Tue, 19 Jan 2010 10:44:55 -0500
To: David Miller <davem@davemloft.net>
Cc: lsorense@csclub.uwaterloo.ca, linux-kernel@vger.kernel.org,
       gabriele.paoloni@intel.com, netdev@vger.kernel.org
Subject: Re: ppp_generic.c severly whitespace damanged by
	9c705260feea6ae329bc6b6d5f6d2ef0227eda0a
Message-ID: <20100119154455.GJ24305@caffeine.csclub.uwaterloo.ca>
References: <20100118225955.GA24307@caffeine.csclub.uwaterloo.ca> <20100119.021301.228036686.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100119.021301.228036686.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 02:13:01AM -0800, David Miller wrote:
> From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
> Date: Mon, 18 Jan 2010 17:59:55 -0500
> 
> > I was just looking at ppp_generic, and noticed that it fairly recently
> > (as in the last year) got rather mangled with many spaces turned into tabs
> > in places they very much shouldn't have been.  I tracked it down to commit
> > 9c705260feea6ae329bc6b6d5f6d2ef0227eda0a (ppp: ppp_mp_explode() redesign).
> > 
> > I am amazed if that patch passed the patch checking script.  I have no
> > idea what kind of weird editor setting did this, but it has to have been a
> > weird editor setting or a very unfortunate search and replace gone wrong.
> > I only found it trying to apply a patch I was playing with and wondering
> > why it wouldn't apply.  Then I found there were tabs in the middle of
> > comments that used to be spaces.
> > 
> > Well here is a patch that should fix it up as far as I can tell.
> > 
> > Purely whitespace repair.  No actual code changes.
> > 
> > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> 
> I'm probably responsible for not catching this sorry.
> 
> Applied to net-next-2.6, thanks.

Great.  I hope I got them all.  I couldn't find anymore searching though.

-- 
Len Sorensen
