Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYEED2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYEED2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 23:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYEED2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 23:28:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:45999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYEED2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 23:28:44 -0400
Date: Mon, 5 May 2008 05:28:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nopage mm.h
Message-ID: <20080505032843.GA14947@wotan.suse.de>
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com> <481D68E0.1040608@gmail.com> <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30805040912l2d12115bi3987d8a5ed0372bf@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 04:12:49PM +0000, Justin Mattock wrote:
> On Sun, May 4, 2008 at 7:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> > Justin Mattock napsal(a):
> >
> > > Hello; I have a question about the nopage function that was removed in
> > > the kernel.
> > > What would be the best way for me to build a module that has a nopage
> > > funtion in it?
> > >
> >
> >  use .fault instead
> >
> Hello thanks for the response, I'll have a look into that. The problem
> I'm confronted with right now is the module is not going to
> install due to it being a non-GPL module. After doing some reading I
> was unawre that the kernel was going GPL-only in 2008, so with that in
> mind I need to comply with the regulations. So the question I have now
> is: Is there a module that is GPL approved that will give me 3D for
> the macbook pro. And also recover from suspend?

Hopefully the driver vendor should provide an update soon. Otherwise,
possibly you could patch back in the .nopage stuff? (It is just a
single commit which does nothing but remove nopage, try reverting it).


