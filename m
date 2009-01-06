Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZAFRwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZAFRwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZAFRvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:51:52 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60132 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZAFRvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:51:52 -0500
Date: Tue, 6 Jan 2009 18:53:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, ccache@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090106175333.GB16365@uranus.ravnborg.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496386EF.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:29:35PM +0000, Jan Beulich wrote:
> >>> "Theodore Ts'o" <tytso@mit.edu> 06.01.09 16:15 >>>
> >In the short term, though, it would be nice if we could get back a
> >simple way of making a kernel  object file using just cc, so that ccache
> >and distcc could be functional again.   Does that seem reasonable?
> 
> Making the new logic dependent on a config option would seem reasonable
> to me - of course at the expense of the respective Makefile becoming
> even less readable.
We need to do this I think - sigh..

The Makefile.build bits should be easiest.
Maybe I should revisit the patch to move vmlinux link to a shell script
to make the toplevel Makefile simpler??

	Sam
