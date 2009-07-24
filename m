Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZGXTKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZGXTKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZGXTKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:10:01 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60645 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZGXTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:10:00 -0400
Date: Fri, 24 Jul 2009 14:09:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC v17][PATCH 00/60] Kernel based checkpoint/restart
Message-ID: <20090724190953.GA22641@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> Application checkpoint/restart (c/r) is the ability to save the state
> of a running application so that it can later resume its execution
> from the time at which it was checkpointed, on the same or a different
> machine.
> 
> This version introduces 'clone_with_pids()' syscall to preset pid(s)
> for a child process. It is used by restart(2) to recreate process
> hierarchy with the same pids as at checkpoint time.
> 
> It also adds a freezer state CHECKPOINTING to safeguard processes
> during a checkpoint. Other important changes include support for
> threads and zombies, credentials, signal handling, and improved
> restart logic. See below for a more detailed changelog.
> 
> Compiled and tested against v2.6.31-rc3.

With the s390 patch I recently sent on top of this set, all of my
c/r tests pass, and ltp behaves the same as on plain v2.6.31-rc3
(up to and including hanging on mallocstress).

-serge
