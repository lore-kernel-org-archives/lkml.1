Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbZFPShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbZFPShT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFPShJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:37:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZFPShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:37:08 -0400
Date: Tue, 16 Jun 2009 14:37:10 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jake Edge <jake@lwn.net>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: problem with function_graph self-test?
In-Reply-To: <20090616122603.6a628097@chukar>
Message-ID: <alpine.DEB.2.00.0906161436200.26673@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 16 Jun 2009, Jake Edge wrote:

> Hi Steve,
> 
> This has taken me a bit to track down ... I built a kernel from Linus's
> git tree (as of this morning: commit
> 03347e2592078a90df818670fddf97a33eec70fb) and when i boot it, it locks
> up hard giving me a cursor in the upper left (which seems to grow then
> shrink once, if that tells anyone anything) and no other output ... i
> started messing with kernel params (turning off quiet, rhgb, adding
> boot_delay and, eventually figuring out i needed lpj as well) to try
> and extract some info ... it seems to reliably fail in the
> function_graph tracer self-test with a variety of messages (I
> unfortunately don't have a serial console on the laptop that I am
> using) ... two of the messages that I got (possibly from different
> boots):
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000048
> BUG: Function graph tracer hang!
> 
> I can try and get more information, but I wanted to check first if you
> already know about this ... somehow i'll either need to type faster :)
> or reliably slow it down and take pictures, which I can do if you'd
> like ...
> 
> obviously, for my purposes, i can turn off the selftests and/or the
> function_graph tracer ...

No I have not seen this before. Could you send me your config. And if you 
can take a digital picture of the dump (if one is available) that would 
also be helpful.

Thanks,

-- Steve

