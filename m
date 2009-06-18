Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbZFRMBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbZFRMBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761582AbZFRMAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:00:53 -0400
Received: from THUNK.ORG ([69.25.196.29]:35815 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761322AbZFRMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:00:51 -0400
Date: Thu, 18 Jun 2009 08:00:40 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/11] vfs: Unmap underlying metadata of new data
	buffers only when buffer is mapped
Message-ID: <20090618120040.GB32164@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <1245088797-29533-8-git-send-email-jack@suse.cz> <20090617103543.GB29931@wotan.suse.de> <20090617120520.GD2612@duck.suse.cz> <20090617135331.GA20678@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617135331.GA20678@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 03:53:31PM +0200, Nick Piggin wrote:
> >   You're right it's not directly connected with the mkwrite problem and
> > can go in separately. Given how late it is, I'd like to get patch number 2
> > reviewed (generic mkwrite changes), so that it can go together with patch
> > number 4 (ext4 fixes) in the current merge window. The rest is not that
> > urgent since it's not oopsable and you can hit it only when running out
> > of space (or hitting quota limit)...
> 
> Sorry I was so late with looking at it. I am reading it now though
> (especially #2) ;)

Thanks, as I have additional ext4 patches which are queued up and
blocked behind these patches.  :-)

						 - Ted
