Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZCGAC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZCGAC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZCGACR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:02:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbZCGACQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:02:16 -0500
Date: Fri, 6 Mar 2009 16:01:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: jeremy@goop.org, yinghai@kernel.org, mingo@elte.hu, tglx@linutronix.de,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce bootmem_state
Message-Id: <20090306160119.f80dd874.akpm@linux-foundation.org>
In-Reply-To: <49B1B2E9.5050507@zytor.com>
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi>
	<49B02498.9080300@kernel.org>
	<49B02C68.1030203@cs.helsinki.fi>
	<49B0640A.5080607@kernel.org>
	<49B0BF46.4080405@zytor.com>
	<49B19FB4.40909@goop.org>
	<49B1B2E9.5050507@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 15:34:01 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Jeremy Fitzhardinge wrote:
> > 
> > Please, no.  system_state should be deprecated; its hard enough to have 
> > a notion of some kind of system-wide state, but putting subsystem 
> > specific substates into it just makes things worse.
> > 
> 
> Does it?  It seems to me to have a bunch of state variables which can 
> interact in $DEITY knows how many ways sounds like a bad idea.
> 

No, that's the whole point.  If each subsystem adds its own
subsystem-private state then the subsystems *won't* interact.

