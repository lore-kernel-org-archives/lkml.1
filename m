Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYK1KGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYK1KGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYK1KFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:05:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55276 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYK1KFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:05:51 -0500
Date: Fri, 28 Nov 2008 10:05:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: T?r?k Edwin <edwintorok@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs, seqfile: make mangle_path() global
Message-ID: <20081128100539.GN28946@ZenIV.linux.org.uk>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <20081123084737.GE30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123084737.GE30453@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 09:47:37AM +0100, Ingo Molnar wrote:
> 
> * T?r?k Edwin <edwintorok@gmail.com> wrote:
> 
> >  fs/seq_file.c            |   14 +++++++-
> >  include/linux/seq_file.h |    1 +
> 
> Note, i've split these bits out into a separate patch - see it 
> attached below.

ACK, except that  I wouldn't use _GPL in the export - it's trivial to
reproduce, so we are not protecting anything here.  And all that code
has been moved verbatim from seq_path(), which is mine *and* exported
without _GPL nonsense.

As far as I'm concerned, all these helpers are as general-purpose as atoi()
et.al. - library functions damn close to being non-copyrightable due both
to triviality and to being absolutely straightforward implementations -
tell anybody to implement it and that's what you'll get.

I'm not fond of proprietary modules, to put it mildly, but let's not get
completely ridiculous.  In this case it's as dumb as schools trying to ban
aspirin in the name of War On Some Drugs.
