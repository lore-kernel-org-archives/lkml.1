Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYCNNae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYCNNae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYCNNaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:30:21 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45591 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbYCNNaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:30:20 -0400
Date: Fri, 14 Mar 2008 09:30:19 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: David Newall <davidn@davidnewall.com>, Jiri Kosina <jkosina@suse.cz>,
       "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080314133019.GE1289@csclub.uwaterloo.ca>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com> <20080313171425.GA4840@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313171425.GA4840@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 06:14:26PM +0100, Pavel Machek wrote:
> hw is proper place to implement autorepeat, and along with some
> buffering, it has chance to work. Kernel is not real-time, and X are
> definitely not real-time, while autorepeat is real-time operation.
> 
> It actually mostly works in ps/2 case. Buffer in hardware means that
> pretty big interrupt delays can be tolerated without problems.

So does the keyboard events generate something like this then:

KEY_x_DOWN
KEY_x_REPEAT
KEY_x_UP

If so then X certainly could get all the keyboard information I imagine
it needs from the kernel, but otherwise I am not sure how it could.  A
repeated series of key down events are not enough since some keys you
don't want repeated you just want to know when the key is held down and
when it isn't.

I just hope someone figures it out since I would love to stop getting
duplicate characters whenever the system is under a bit of load in X.

--
Len Sorensen
