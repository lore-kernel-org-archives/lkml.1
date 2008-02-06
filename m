Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYBFKf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYBFKf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 05:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYBFKfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 05:35:12 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:44782 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYBFKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=mU9FICCmYRxT2flOQQmHI29metFliomUPGHGOOSOnohAFxzriEoFuokVSe1z7+bw5/Pf3CpTWI0xuGf4ofbjYiOh5UAUOrc6VJl3se7BAekn7CX5Ni7BXxvo/g8P2LOk7AdulKzAMasIWGAwBw9g5RMIt/bltwP1J6XA3MY3MRE=
Date: Wed, 6 Feb 2008 11:35:10 +0100
To: "Mader, Alexander (N-MSR)" <Alexander.Mader@niles.de>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "Stuge, Peter" <stuge-linux-pcmcia@cdy.org>
Subject: Re: Resolved (sort of): Unable to access PCMCIA with O2 Micro
 OZ711MP1/MS1
Message-Id: <20080206113510.20f26299.Kristoffer.ericson@gmail.com>
In-Reply-To: <47A96983.1090108@niles.de>
References: <47A7F828.1010303@niles.de>
	<20080205140622.bf41f3ce.Kristoffer.ericson@gmail.com>
	<47A96983.1090108@niles.de>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2008 09:02:11 +0100
"Mader, Alexander (N-MSR)" <Alexander.Mader@niles.de> wrote:

> Kristoffer Ericson schrieb:
> > "Mader, Alexander (N-MSR)" wrote:
> >> On a Fujitsu Siemens Celsius H240 a 2.6.22-3-amd64 kernel from Debian 
> >> testing is in use. PCMCIA utilities for Linux 2.6 version 014-4 are 
> >> installed. I could supply the output of lspci and lshal.
> > 
> > Assuming debian has alot of patches applied, it would be interesting to see
> > if this bug exist on vanilla 2.6.24. Would probably get alot more attention from
> > pcmcia guru's.
> 
> Hello,
> 
> obviously this is the case. This morning I tried a different non-cardbus 
> PCMCIA card and it worked, which in turn was the case for the other test 
> candidates, NICs and CF adapters: they all are accessible right now. In 
> the moment I am trying to find out which update caused the improvement.

Glad to hear its working. If you are eager to see what patch caused the bug (debian or vanilla) you can
always do a bisect. Or simply run through 2.6.20 -> 2.6.24 vanilla kernels and see where it worked and when it didn't.

> 
> Thank you very much for your attention and, please, excuse me for 
> bothering you.
> 

no worries.

> Best regards, Alexander.
