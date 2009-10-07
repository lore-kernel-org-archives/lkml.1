Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZJGDxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZJGDxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZJGDxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:53:17 -0400
Received: from fifo99.com ([67.223.236.141]:53514 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZJGDxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:53:16 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Daniel Walker <dwalker@fifo99.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <m33a5ww8kn.fsf@intrepid.localdomain>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop>  <m33a5ww8kn.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 20:52:14 -0700
Message-Id: <1254887534.18167.253.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 22:50 +0200, Krzysztof Halasa wrote:
> Daniel Walker <dwalker@fifo99.com> writes:
> 
> > In terms of the list getting long or not, your basically in control of
> > it since you maintain checkpatch .. If you leave it without some sort of
> > blacklist, then you end up with whole sections of code where the
> > developers don't use checkpatch at all (or very little)..
> 
> Why? I routinely ignore specific warnings from checkpatch while paying
> attention to other ones. That's precisely what one should expect if the
> code in question technically violates the common style (or whatever is
> it). I don't think we need exceptions in the checkpatch as they would
> make it less useful and less reliable.

This thread is specifically about checkpatch errors .. checkpatch
warnings can be ignored, but errors you can't usually ignore.. If your
ignoring errors then either checkpatch is producing bogus output that
needs to be corrected, or it's something you really should fix..

Daniel

