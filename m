Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYFDFMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYFDFMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYFDFMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:12:38 -0400
Received: from keil-draco.com ([216.193.185.50]:54528 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYFDFMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:12:37 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Date: Wed, 4 Jun 2008 01:12:34 -0400
User-Agent: KMail/1.9.9
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@linux-foundation.org>,
       Nix <nix@esperi.org.uk>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603210048.GA12182@c2.user-mode-linux.org> <m1zlq2vuh2.fsf@frodo.ebiederm.org>
In-Reply-To: <m1zlq2vuh2.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806040112.35245.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 09:50:49 pm Eric W. Biederman wrote:
> Jeff Dike <jdike@addtoit.com> writes:
> > On Tue, Jun 03, 2008 at 01:07:09PM -0700, Andrew Morton wrote:
> >> So if I change the host's time by an hour, the time will not advance at
> >> all on the guest for the next hour? Sounds suboptimal :)
> >
> > It is, but if the host is whacked, the guest just has to do the best that
> > it can...
>
> Could using a CLOCK_MONOTONIC time source fix this?  Those timers do not
> change when we change the time on the host.
>
> Eric

I'm not all that familiar with the specifics of the code - my original 
statements about possible causes were barely more than wild guesses - but 
this does sound like it would work.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
