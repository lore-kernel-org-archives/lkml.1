Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYIZMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYIZMsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYIZMrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:47:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34042 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbYIZMry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:47:54 -0400
Date: Fri, 26 Sep 2008 13:45:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, Jing Huang <huangj@brocade.com>,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com,
       vravindr@brocade.com
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2nd
 try)
Message-ID: <20080926134534.5a7d4897@lxorguk.ukuu.org.uk>
In-Reply-To: <20080926122219.GV27204@parisc-linux.org>
References: <200809260054.m8Q0slEL027478@swe37.brocade.com>
	<200809260841.39433.eike-kernel@sf-tec.de>
	<20080926122219.GV27204@parisc-linux.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008 06:22:19 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Sep 26, 2008 at 08:41:31AM +0200, Rolf Eike Beer wrote:
> > You should use pcim_enable_device(). This would help you by simplifying your 
> > error and release code as it keeps track of freeing a bunch of resources. See 
> > Documentation/driver-model/devres.txt.
> 
> I hate the devres stuff.  It takes care of most things behind your back,
> but is terribly complex code and makes bugs next to impossible to track
> down.  Don't add more users for it unless you really, really have to.

Each to his own. I find the devres code very useful, but then I spend an
inordinate amount of time trying to sort out messes caused by developers
forgetting to free resources.

Using devres is a very good way to avoid having strange half tested paths
and leaks in your code, and if Matthew doesn't like the complexity of
devres (its not that complex IMHO) then he can tidy up the
implementation ;)

Alan
