Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbZLQDDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbZLQDDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbZLQDD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:03:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38313 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbZLQDD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:03:28 -0500
Date: Thu, 17 Dec 2009 03:02:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <rdreier@cisco.com>, Andrew Isaacson <adi@vmware.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Message-ID: <20091217030222.GU14381@ZenIV.linux.org.uk>
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B299AB5.7020109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B299AB5.7020109@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 06:43:01PM -0800, H. Peter Anvin wrote:
> On 12/16/2009 05:39 PM, Roland Dreier wrote:
> > Is there any reason not to apply the patch below, to allow more awk
> > implementations to be used?  After all, it's not like we're going to put
> > non-ASCII characters into the map file...
> 
> I guess the question is if it will break under any other circumstances,
> but I guess we can find those when we get to them.
> 
> There was a long discussion about the use of awk on IRC today.
> Apparently mawk, in particular, is actively broken, because the
> maintainer believe that POSIX is crap.  There are quite a few issues
> with it, according to reports.
 
still is more compact than gawk, less loaded with GNU "extensions" and
happens to be default on debian and debian-derived userlands.
