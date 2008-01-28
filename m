Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYA1Q3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYA1Q3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYA1Q3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:29:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYA1Q3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:29:07 -0500
Date: Mon, 28 Jan 2008 10:20:31 -0600
From: David Teigland <teigland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, fabbione@ubuntu.com
Subject: Re: [PATCH 07/19] dlm: swap bytes for rcom lock reply
Message-ID: <20080128162031.GA18714@redhat.com>
References: <1201193442-8260-8-git-send-email-teigland@redhat.com> <20080126220029.98dc3826.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126220029.98dc3826.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 10:00:29PM -0800, Andrew Morton wrote:
> > On Thu, 24 Jan 2008 10:50:30 -0600 David Teigland <teigland@redhat.com> wrote:
> >  void dlm_rcom_in(struct dlm_rcom *rc)
> >  {
> >  	struct dlm_header *hd = (struct dlm_header *) rc;
> 
> aww, c'mon guys, this is nonsense.
> 
> 	struct dlm_header *hd = &rc->rc_header;
> 
> there seems to be rather a lot of this unnecessary casting going on in dlm. 
> Please do a hunt-and-exterminate.

Yes, there's a fair bit of that kind of cleanup I'd like to do.  I'll add
another cleanup-only patch to the series that at least makes a start on
it.  Thanks
Dave

