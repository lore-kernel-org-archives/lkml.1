Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZHCSWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZHCSWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZHCSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:22:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55252 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZHCSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:22:50 -0400
Date: Mon, 3 Aug 2009 13:22:49 -0500
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
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC v17][PATCH 14/60] pids 4/7: Add target_pids parameter to
	alloc_pid()
Message-ID: <20090803182249.GA7493@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-15-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248256822-23416-15-git-send-email-orenl@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> This parameter is currently NULL, but will be used in a follow-on patch.

Note that patches 1-4 of the clone_with_pid() patchset should
also be useful if we decide to re-create process trees in-kernel
and not export clone_with_pid().  (Though maybe not immediately
applicable to Alexey's current kthread_run()-based approach).

-serge
