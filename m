Return-Path: <linux-kernel-owner+w=401wt.eu-S933959AbYEFXzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbYEFXzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbYEFXzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:55:11 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:43873 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYEFXzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:55:10 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 11/19] UML - Track and make up lost ticks
References: <20080425175613.GA11192@c2.user-mode-linux.org>
	<877iegcx11.fsf@hades.wkstn.nix>
	<20080429202924.GA13602@c2.user-mode-linux.org>
	<20080506134655.4cac1014.akpm@linux-foundation.org>
	<20080506214435.GA12998@c2.user-mode-linux.org>
	<20080506150126.c849afa0.akpm@linux-foundation.org>
From: Nix <nix@esperi.org.uk>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Date: Wed, 07 May 2008 00:54:50 +0100
In-Reply-To: <20080506150126.c849afa0.akpm@linux-foundation.org> (Andrew Morton's message of "Tue, 6 May 2008 15:01:26 -0700")
Message-ID: <87zlr36l9x.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-sonic.net-Metrics: hades 1117; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2008, Andrew Morton uttered the following:

> On Tue, 6 May 2008 17:44:35 -0400
> Jeff Dike <jdike@addtoit.com> wrote:
>
>> On Tue, May 06, 2008 at 01:46:55PM -0700, Andrew Morton wrote:
>> > This fix was already present in your "[PATCH 4/19] UML - Random driver fixes".
>> 
>> Ah, so that's where it ended up.
>
> Strange that the bug has always been there.  Some other change made it
> apparent?

Yeah, there was a re-prototyping of the broken prototype above the only
use outside the file where the function is defined, and this patch
removed that re-prottyping. :)
