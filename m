Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYKZRlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYKZRlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYKZRlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:41:39 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58268 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYKZRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:41:38 -0500
Date: Wed, 26 Nov 2008 18:39:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Detecting endianness in scripts/recordmcount.pl?
Message-ID: <20081126173935.GA29692@uranus.ravnborg.org>
References: <20081126083905.GA20472@linux-sh.org> <20081126135441.GB28170@uranus.ravnborg.org> <alpine.DEB.1.10.0811261213300.26743@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811261213300.26743@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > The CONFIG_64BIT test could likewise be adopted for testing endianness, but
> > > not all architectures have config options for endian selections.
> > But we could add this - no?
> > Much better than executing objdump one thousand times.
> 
> Adding a parameter would be better.

Which moves the problem to the caller which is OK.
And then we are back to the same discussion and again we should
introduce a CONFIG_ symbol for it.

	Sam
