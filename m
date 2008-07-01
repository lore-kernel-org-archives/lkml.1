Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYGAIV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYGAIV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYGAIVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:21:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:59372 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYGAIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:21:38 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH]  aio: remove unused function aio_run_iocbs()
Date: Tue, 1 Jul 2008 13:55:50 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
References: <200806261640.27048.knikanth@suse.de> <x49lk0rt3x6.fsf@segfault.boston.devel.redhat.com> <48691AA2.7050201@oracle.com>
In-Reply-To: <48691AA2.7050201@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807011355.51049.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 23:10:50 Zach Brown wrote:
> Jeff Moyer wrote:
> > Nikanth Karthikesan <knikanth@suse.de> writes:
> >> remove unused function aio_run_iocbs()
> >
> > Seems like it's time to just get rid of it.  See:
> >   http://ussg.iu.edu/hypermail/linux/kernel/0608.0/0048.html
> > for an explanation of why it's still there.
>
> Yeah, I'm still of the opinion that the cost of having to resurrect it
> if it's needed again isn't significant enough to keep it in the tree
> without callers.
>

Can't this function be kept as part of the out-of-tree patch itself? Or is it 
a module that requires this symbol? I do not see a EXPORT_SYMBOL*() for this, 
so it cannot be a module depending on this func!?

Thanks
Nikanth Karthikesan


