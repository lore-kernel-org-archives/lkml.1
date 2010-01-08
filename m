Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246Ab0AHL5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0AHL5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133Ab0AHL5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:57:48 -0500
Received: from cantor.suse.de ([195.135.220.2]:58182 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab0AHL5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:57:47 -0500
Date: Fri, 8 Jan 2010 12:57:45 +0100
From: Michal Marek <mmarek@suse.cz>
To: Simon Horman <horms@verge.net.au>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Roland Dreier <rdreier@cisco.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] Makefile: Unexport LANG
Message-ID: <20100108115745.GA14758@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B467FCB.2080101@zytor.com>
 <20100108025924.GE2465@verge.net.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 04:43:55PM -0800, H. Peter Anvin wrote:
> On 01/07/2010 04:41 PM, Simon Horman wrote:
> > On Sat, Dec 26, 2009 at 10:20:07PM +1100, Simon Horman wrote:
> >> On Fri, Dec 25, 2009 at 09:14:40PM -0800, H. Peter Anvin wrote:
> I think it's up to Michal to pick the preferred solution.
> 
> It has been pointed out that one option might also to be to *not*
> override LC_CTYPE, and only override LC_COLLATE.

Yes, that's imo a good compromise. As I noted in another thread, the
only drawback of not setting LC_CTYPE is that it makes the behavior of
awk's tolower()/toupper() volatile, but that seems to be only used in a
single script. I'll post a patch in a separate email.


On Fri, Jan 08, 2010 at 01:59:24PM +1100, Simon Horman wrote:
> Is it just me or is Michal's email bouncing of late?

My email address was wrong, sues.cz does not exist, suse.cz does. Which
is why I overlooked this thread.

Michal
