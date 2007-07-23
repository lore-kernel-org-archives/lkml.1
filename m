Return-Path: <linux-kernel-owner+w=401wt.eu-S934693AbXGWTji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbXGWTji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbXGWTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:39:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763191AbXGWTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:39:29 -0400
Date: Mon, 23 Jul 2007 20:39:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Modra <amodra@bigpond.net.au>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723193923.GL21668@ftp.linux.org.uk>
References: <20070723180048.GA8268@uranus.ravnborg.org> <20070723191215.2F9484D058D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723191215.2F9484D058D@magilla.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 12:12:15PM -0700, Roland McGrath wrote:
> > rm vmlinux*; time make vmlinux
> > 
> > Vanilla tree: ~7,7 sec
> > With single shot ld (Roland's patch): 8,3 secs
> 
> Shouldn't you compare:
> 	rm vmlinux*; find . -name built-in.o -print | xargs rm
> 	time make vmlinux
> or something like that?

No.  You are talking about the time of full build; there it would
be relevant.  For incrementals it's definitely not so.
