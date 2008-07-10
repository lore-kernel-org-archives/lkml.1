Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYGJJSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYGJJSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYGJJSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:18:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYGJJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:18:45 -0400
Date: Thu, 10 Jul 2008 02:13:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] quota: Fix possible infinite loop in quota code
Message-Id: <20080710021304.e5409793.akpm@linux-foundation.org>
In-Reply-To: <20080710090553.GA21047@duck.suse.cz>
References: <12156246412443-git-send-email-jack@suse.cz>
	<20080709151254.9a36bdd8.akpm@linux-foundation.org>
	<20080710090553.GA21047@duck.suse.cz>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 11:05:53 +0200 Jan Kara <jack@suse.cz> wrote:

> On Wed 09-07-08 15:12:54, Andrew Morton wrote:
> > On Wed,  9 Jul 2008 19:30:41 +0200 Jan Kara <jack@suse.cz> wrote:
> > 
> > > When quota structure is going to be dropped and it is dirty, quota code
> > > tries to write it. If the write fails for some reason (e. g. transaction
> > > cannot be started because the journal is aborted), we try writing again
> > > and again and again... Fix the problem by clearing the dirty bit even if
> > > the write failed.
> > 
> > What do you consider the priority is here?  Needed in 2.6.26?  Backport to
> > 2.6.25.x?  Merge into 2.6.27 with a backport to 2.6.26.x and 2.6.25.x?
> > 
> > Lots of options ;)
>   Since nobody has really seen it in the wild, I don't think it's urgent.
> The bug has been there for 5 years or so without notice... I'd just let it
> be included in 2.6.26.x maybe 2.6.25.x and push into 2.6.27.
> 

So noted, thanks.
