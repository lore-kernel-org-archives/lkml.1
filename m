Return-Path: <linux-kernel-owner+w=401wt.eu-S1762324AbYJJR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbYJJR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbYJJR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:28:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51607 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397AbYJJR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:28:33 -0400
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Cedric Le Goater <clg@fr.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1223657132.10017.42.camel@localhost.localdomain>
References: <20081009190405.13A253CB@kernel>
	 <20081009190406.1B257119@kernel> <48EF2BAB.1010009@fr.ibm.com>
	 <20081010140430.GA14640@us.ibm.com>
	 <1223657132.10017.42.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 10:28:27 -0700
Message-Id: <1223659707.11830.57.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 18:45 +0200, Greg Kurz wrote:
> It's exactly what I meant before, the tracking facility would be awfully
> complicated. It cannot be done that way.
> But there's also something awkward with the flag thing : can you provide
> right now an exhaustive list of all the places where you must raise it ?

Greg, that's just pure FUD.  We don't say that spinlocks are a bad thing
because we can't come up with an exhaustive list of places where we need
locking.

We'll do plenty of checks at checkpoint time.

We'll do plenty of checks at runtime.

Neither will work completely on its own, and neither will be exhaustive.
The way this will work is just as Serge said: in true Linux style, we'll
add more places users of process_deny_checkpoint() incrementally as we
find them and as people complain.  We'll also be incrementally removing
them as we add functionality.

-- Dave

