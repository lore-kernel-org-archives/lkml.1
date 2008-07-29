Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYG2XOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYG2XOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYG2XOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:14:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108AbYG2XOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:14:19 -0400
Date: Tue, 29 Jul 2008 16:13:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
Subject: Re: [PATCH 0/30] W1: w1 core fixes, ds2490 updates, strong pullup
Message-Id: <20080729161356.2de456fb.akpm@linux-foundation.org>
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 21:04:33 -0500
David Fries <david@fries.net> wrote:

> What follows is a long list of fixes and enhancements to the one wire
> system, and even some documentation.
> 
> I no longer have any deadlocks, a thread was eliminated (along with
> its one second wakeup interval), the cpu and time overhead are much
> reduced for one wire accesses.  The time for the ds2490 to read a
> temperature sensor went from 3.91 seconds (.002s user, 3.001s system)
> to 0.860 seconds (0.004s user, 0.004s system).  I also added support
> for the strong pullup to provide more current when requested.

This is all dreadfully late for 2.6.27, but it does seem to be rather
important, so let's aim for 2.6.27.


The w1 code seems to have rather a lot of comments which start with /**
but which aren't kerneldoc comments.  But /** is exclusively used to
signify the start of a kerneldoc comment.  Please let's not invent new
commenting styles like this.  Documentation/CodingStyle is there to
help.


Please be aware that this:

Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"

is rather receiver-hostile.  My MUA (at least) (sylpheed) manages to
make a complete mess when saving-to-file, so I needed to go through all
the patches and do various manual steps to fix this up.  I may still have
some "=066"s in the changelogs.

Also, some MUAs (but not sylpheed) may be unable to quote the patch
text when someone does a reply to your email, which is also a bit of a
hassle.

Nothing beats plain old ascii text.  Preferably non-wordwrapped,
non-tab-replaced, non-spacestuffed ascii text (which is becoming
increasingly rare).


