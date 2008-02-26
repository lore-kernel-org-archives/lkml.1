Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbYBZES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbYBZES1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYBZESS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:18:18 -0500
Received: from ozlabs.org ([203.10.76.45]:59645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYBZESS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:18:18 -0500
Date: Mon, 25 Feb 2008 22:13:49 -0600
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080226041349.GA17772@kryten>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080220091022.GB31424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220091022.GB31424@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > From: Soren Sandmann <sandmann@redhat.com>
> > Subject: [PATCH] x86: add the debugfs interface for the sysprof tool
> > 
> > The sysprof tool is a very easy to use GUI tool to find out where 
> > userspace is spending CPU time. See 
> > http://www.daimi.au.dk/~sandmann/sysprof/ for more information and 
> > screenshots on this tool.
> > 
> > Sysprof needs a 200 line kernel module to do it's work, this module 
> > puts some simple profiling data into debugfs.
> 
> thanks, looks good to me - applied.

Woah slow down guys. Did I miss the review?

Yes it's a 200 line patch, but it's a 200 line x86 patch. Surely we
should apply some of the same rigour we did when we merged the oprofile
patch? Is it biarch safe? Will it run on powerpc, arm etc?

I'm still struggling to understand why we need this functionality at
all. Lets argue the ABI and not cloud it with a discussion about
userspace eye candy. What does this give you that is an improvement over
the oprofile kernel-user ABI?

Anton
