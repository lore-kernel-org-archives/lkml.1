Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYJFE3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYJFE3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 00:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYJFE3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 00:29:46 -0400
Received: from kroah.org ([198.145.64.141]:51286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626AbYJFE3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 00:29:45 -0400
Date: Sun, 5 Oct 2008 21:08:20 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, David Smith <dsmith@redhat.com>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [PATCH] Marker depmod fix core kernel list
Message-ID: <20081006040820.GB26148@kroah.com>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org> <20081003195436.GA13506@Krystal> <20081004152456.GB23398@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004152456.GB23398@mit.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 11:24:56AM -0400, Theodore Tso wrote:
> On Fri, Oct 03, 2008 at 03:54:36PM -0400, Mathieu Desnoyers wrote:
> > Here is a fix that should take care if this problem. Given I am not the
> > modpost expert, let's see if I can get an ACK from Sam.
> 
> Tested-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> It works, thanks!!  Can we get this pushed to Linus before 2.6.28
> opens?  This is technically a regression since it was broken around
> 2.6.27-rc1.

If it misses .27, can someone forward it to stable@kernel.org when it
goes into Linus's tree?

thanks,

greg k-h
