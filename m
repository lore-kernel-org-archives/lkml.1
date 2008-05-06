Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbYEFWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbYEFWCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbYEFWBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:01:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbYEFWBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:01:51 -0400
Date: Tue, 6 May 2008 15:01:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: nix@esperi.org.uk, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 11/19] UML - Track and make up lost ticks
Message-Id: <20080506150126.c849afa0.akpm@linux-foundation.org>
In-Reply-To: <20080506214435.GA12998@c2.user-mode-linux.org>
References: <20080425175613.GA11192@c2.user-mode-linux.org>
	<877iegcx11.fsf@hades.wkstn.nix>
	<20080429202924.GA13602@c2.user-mode-linux.org>
	<20080506134655.4cac1014.akpm@linux-foundation.org>
	<20080506214435.GA12998@c2.user-mode-linux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 17:44:35 -0400
Jeff Dike <jdike@addtoit.com> wrote:

> On Tue, May 06, 2008 at 01:46:55PM -0700, Andrew Morton wrote:
> > This fix was already present in your "[PATCH 4/19] UML - Random driver fixes".
> 
> Ah, so that's where it ended up.

Strange that the bug has always been there.  Some other change made it
apparent?


> > Perhaps we broke bisection?
> 
> No doubt.  Drop those two and I'll send fixed ones.

OK.  uml-random-driver-style-fixes.patch needed to go also.
