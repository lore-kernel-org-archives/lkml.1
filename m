Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbYDKMLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbYDKMLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 08:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYDKMLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 08:11:40 -0400
Received: from nn7.de ([85.214.94.156]:35819 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbYDKMLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:11:40 -0400
Subject: Re: suspend issue
From: Soeren Sonnenburg <kernel@nn7.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080411105712.GC18770@elf.ucw.cz>
References: <dd18b0c30804052103s7357bb86yf7bf11d38d2911b3@mail.gmail.com>
	 <1207490104.4597.36.camel@localhost> <20080406232849.GA789@elf.ucw.cz>
	 <1207736730.4320.1.camel@localhost> <20080410100234.GB11084@ucw.cz>
	 <1207865152.21472.2.camel@localhost>  <20080411105712.GC18770@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Apr 2008 14:11:29 +0200
Message-Id: <1207915890.4526.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 12:57 +0200, Pavel Machek wrote:
> On Fri 2008-04-11 00:05:52, Soeren Sonnenburg wrote:
[...]
> > > Well, 2.6.20 worked, so bisect should be easy, right?
> > 
> > I don't quite understand... 2.6.24 worked yes, but 2.6.25-rc1 didn't
> > even *suspend*. However the problem lies not in suspending but no
> > display on *resume*. So the bug is hidden by the hang on suspend and I
> > don't see how I can check when resume broke.
> 
> Hmm, you could bisect the resume regression, revert that, and then go
> on to find the suspend regression.
> 
> ...ok, not easy, I see.
> 
> Do you have kernel.org bugzilla # I could look at? Perhaps this can be
> debugged using printks or something...

http://bugzilla.kernel.org/show_bug.cgi?id=10319

Soeren
