Return-Path: <linux-kernel-owner+w=401wt.eu-S1760304AbXGLG51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304AbXGLG51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXGLG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:57:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbXGLG5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:57:18 -0400
Date: Wed, 11 Jul 2007 23:56:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jan Kara <jack@suse.cz>,
       Kirill Korotaev <dev@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: Lost JBD fix
Message-Id: <20070711235640.bb854b89.akpm@linux-foundation.org>
In-Reply-To: <20070712065009.GM4587@kernel.dk>
References: <20070709181443.GF30433@duck.suse.cz>
	<46951992.8040700@redhat.com>
	<20070712065009.GM4587@kernel.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 08:50:11 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> > > -	if (commit_transaction->t_checkpoint_list == NULL) {
> > > +	if (commit_transaction->t_checkpoint_list == NULL &&
> > > +	    commit_transaction->t_checkpoint_io_list == NULL) {
> > >  		__journal_drop_transaction(journal, commit_transaction);
> > >  	} else {
> > >  		if (journal->j_checkpoint_transactions == NULL) {
> > 
> > Critical bugfix -- 2.6.22-stable (no earlier versions) should get
> > this too, right?
> 
> And don't forget that we have a jbd2/ clone as well, for the hugely
> succesful ext4 project as well.

Yeah, I did that.  Again.
