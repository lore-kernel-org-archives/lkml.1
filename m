Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYJDANy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYJDANy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 20:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYJDANq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 20:13:46 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:36265 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYJDANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 20:13:45 -0400
Date: Sat, 4 Oct 2008 01:13:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8 doubled times
In-Reply-To: <alpine.LFD.2.00.0810040020300.4404@apollo>
Message-ID: <Pine.LNX.4.64.0810040111020.9858@blonde.site>
References: <Pine.LNX.4.64.0810031104080.28598@blonde.site>
 <alpine.LFD.2.00.0810040020300.4404@apollo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008, Thomas Gleixner wrote:
> On Fri, 3 Oct 2008, Hugh Dickins wrote:
> > Hi Thomas,
> > 
> > Please would you take another look at your -rc8 commit
> > 302745699c1b675b5d2a1af87271de10e4d96b6a clockevents:
> > check broadcast device not tick device.
> 
> Bummer. I can swear that I had a fix for this in the quilt queue
> before I applied it to the git tree.
> 
> The correct fix is below.

Indeed, that now gives me a reasonable 174%CPU on the Duo, thanks.
And my other machines still give sensible times with that patch in.

Hugh
