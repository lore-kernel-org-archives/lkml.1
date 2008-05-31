Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYEaNaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYEaNaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYEaNaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:30:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752487AbYEaNaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:30:00 -0400
Date: Sat, 31 May 2008 14:15:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Frey <cdfrey@foursquare.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOM policy, overcommit control, and soft limits
Message-ID: <20080531141529.2a5c085a@core>
In-Reply-To: <20080531102752.GA25244@foursquare.net>
References: <20080531102752.GA25244@foursquare.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm sure someone has thought of this before me.  Does anything remotely
> similar to this already exist?  I've googled for OOM policy, but so far
> all I've seen is Rusty Lynch's patch from 2003, and really, I want this
> behaviour to happen when there is still a bit of memory left, so things
> can be dealt with before they are OOM-level dire.

Not that I am aware of. However you can set priorities on OOM killing
order and there is a patch from the XO people which seems to have
vanished into the darkness which added a nice memory pressure notifier so
apps could respond to memory shortages intelligently (eg by cleaning up)

