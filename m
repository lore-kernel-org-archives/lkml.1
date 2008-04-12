Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYDLRXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYDLRXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 13:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYDLRW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 13:22:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:19527 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbYDLRW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 13:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iSucmEL4whxBocJEAu6QZuMu8IZI0tphx0c8+TwqIC4ZRLl6rwTjBiXHdYpjx8mqdShNN34X2YioNE0YxDjUwwE+1BbLqt0/3xrg0Zlh43z9yDUCQjrTtnqXKlRu3gR7wR5AKVk9rsm95+BlgDG4w+T6sQBNz2jN3IvlJo2+KdQ=
Message-ID: <86802c440804121022x51ce5a90m110b22132d3a0cb9@mail.gmail.com>
Date: Sat, 12 Apr 2008 10:22:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] mm/slab.c boot crash in -git, "kernel BUG at mm/slab.c:2103!"
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Mel Gorman" <mel@csn.ul.ie>, "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <Pine.LNX.4.64.0804120329390.23255@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411074145.GA4944@elte.hu>
	 <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com>
	 <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com>
	 <20080411085411.GA10181@elte.hu>
	 <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com>
	 <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com>
	 <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com>
	 <20080411092452.GE10801@elte.hu>
	 <Pine.LNX.4.64.0804111228100.20334@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0804120329390.23255@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 3:38 AM, Christoph Lameter <clameter@sgi.com> wrote:
> Pekka pointed out the orig post that had the boot info.
>
> One commonality in the two failures inhouse and yours is that
> both had more than 4G memory and had CONFIG_HIGHMEM4G set. Possibly
> a wraparound of some limit?

Ingo,

does your old 8 socket system work with 64bit kernel?

YH
