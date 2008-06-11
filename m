Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYFKGdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYFKGdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFKGc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:32:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7017 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYFKGc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CbsmZteeSB2aIflqme/bafFXlVohZOIIHCwTwUrUUyWYX5HQJPq/A49ZDkLIajT1V8
         XRzbK6iDOy9G0A02VH2mS0USsYPteYPuvh3wANJl9aU02AXEz978NWP/LoY86miUkasc
         4Om6uBzbsVdr0fCQ5o1EpB9j1aofqwvEssqgM=
Date: Wed, 11 Jun 2008 10:28:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25.6
Message-ID: <20080611062856.GB5011@martell.zuzino.mipt.ru>
References: <20080609194924.GL30402@sequoia.sous-sol.org> <20080610145325.GC23351@khazad-dum.debian.net> <20080610191726.GB4218@tatooine.rebelbase.local> <20080610195747.GA18926@martell.zuzino.mipt.ru> <20080610230645.GA16711@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610230645.GA16711@khazad-dum.debian.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 08:06:45PM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 10 Jun 2008, Alexey Dobriyan wrote:
> > Person fixing a bug may not realize he fixes security-sensitive bug.
> 
> That is a valid reason, I am pretty sure everyone here (including me) has
> been guilty of that one.  Which doesn't mean we can't do better to educate
> ourselves on the patterns for the most common issues.  The "fix for a
> null-dereference to anything that has a function pointer in it" is such a
> pattern.

Sure.

> > Or simply doesn't care because there are 5 more to fix for today.
> 
> THAT, however, is unacceptable IMO. If one can't be bothered, or one
> doesn't have the time (or the skill, whatever) to access the severity of a
> fix, he should ask for someone to do that on the commit message.  One extra
> short sentence at the end of the commit message [asking for that help] is
> DEFINATELY not too much to ask.

I just realized crapload of NULL dereferences were fixed in /proc and
near last couple of releases.

They were never proposed for any -stable.

And, in retrospective, they wouldn't have been marked as security
sensitive.

Do you read OpenBSD commit logs?

