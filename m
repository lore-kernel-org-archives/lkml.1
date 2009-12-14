Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbZLNXVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbZLNXVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbZLNXVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:21:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925AbZLNXVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:21:12 -0500
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>,
       lenb@kernel.org
Subject: Re: RFC: A proposal for power capping through forced idle in the Linux  Kernel
From: Andi Kleen <andi@firstfloor.org>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
Date: Tue, 15 Dec 2009 00:21:07 +0100
In-Reply-To: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com> (Salman Qazi's message of "Mon, 14 Dec 2009 15:11:47 -0800")
Message-ID: <876389xhuk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salman Qazi <sqazi@google.com> writes:
>
> We'd like to get as much of our stuff upstream as we can.  Given that
> this is a somewhat sizable chunk of work, it would be impolite of me
> to just send out a bunch of patches without hearing the concerns of
> the community.  What are your thoughts on our design and what do we
> need to change to get this to be more acceptable to the community?  I
> also would like to know if there are any existing pieces of
> infrastructure that this can utilize.

There were a lot of discussions on this a few months ago in context
of the ACPI 4 "power aggregator" which is a similar (perhaps
slightly less sophisticated) concept. 

While there was a lot of talk about teaching the scheduler about this 
the end result was just a driver which just starts real time threads
and then idles in them. This is in current mainline.

It might be a good idea to review these discussions in the archives.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
