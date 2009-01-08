Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbZAHTRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbZAHTRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbZAHTRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:17:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499AbZAHTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:17:04 -0500
Date: Thu, 8 Jan 2009 14:16:55 -0500
From: Kyle McMartin <kyle@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Beulich <jbeulich@novell.com>, ccache@lists.samba.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090108191655.GB15334@bombadil.infradead.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu> <49647B00.76E4.0078.0@novell.com> <20090107113138.GA29730@uranus.ravnborg.org> <4964AF8D.76E4.0078.0@novell.com> <20090107132337.GA2289@uranus.ravnborg.org> <4964C0A3.76E4.0078.0@novell.com> <20090107200646.GF4647@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107200646.GF4647@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 09:06:46PM +0100, Sam Ravnborg wrote:
> > Looks good to me. In case you decide to revert the stuff for .29, I'll
> > merge this into my patch.
> As it stand now it:
> 1) breaks sparc32 build
> 2) causes regression with distcc/ccache use when MODVERSIONS are enabled
> 3) the concept is under discussion
> 

4) Bloats distro modules from 48M to >1GB when stripping fails. :\

regards, Kyle
