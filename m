Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYDRCAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYDRCAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 22:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYDRCAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 22:00:35 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:27161 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYDRCAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 22:00:34 -0400
Date: Thu, 17 Apr 2008 22:00:33 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace_signal subroutine
Message-ID: <20080418020033.GI23641@phobos.i.cabal.ca>
References: <20080418014438.1C93C27037D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418014438.1C93C27037D@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 06:44:38PM -0700, Roland McGrath wrote:
> This breaks out the ptrace handling from get_signal_to_deliver
> into a new subroutine.  The actual code there doesn't change, and
> it gets inlined into nearly identical compiled code.  This makes
> the function substantially shorter and thus easier to read, and
> it nicely isolates the ptrace magic.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Nice clean up.

cheers, Kyle
