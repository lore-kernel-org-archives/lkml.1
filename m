Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZDXHlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZDXHlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZDXHkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:40:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:46714 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZDXHkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:40:53 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH linux-2.6-block/for-linus] Fix discard requests accounting in the diskstats
Date: Fri, 24 Apr 2009 13:08:35 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
References: <200904232013.n3NKD4PP017241@imap1.linux-foundation.org> <200904241118.30919.knikanth@suse.de> <20090424061518.GY4593@kernel.dk>
In-Reply-To: <20090424061518.GY4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904241308.35738.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009 11:45:18 Jens Axboe wrote:
> On Fri, Apr 24 2009, Nikanth Karthikesan wrote:
> > When 2 discard requests are merged, the stats gets updated, but we do not
> > update statistics normally when a discard request is issued or completed.
> > For example the in_flight counter would be decremented when 2 discard
> > requests are merged, but it was not at all incremented when they were
> > issued, and in_flight counter will not be decremented, when they are
> > completed as well.
> >
> > This patch fixes this by adding discard requests to the statistics.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
>
> OK, so that's not quite what I had in mind. If we first do this as a
> preparatory patch:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=42fd769da4edadad83a7
>79867ff1910ec35c6de7
>

Oh! I thought this cleanup along with the 
block-turn-some-buggy-macros-into-c-functions.patch from Andrew could be done 
on top of my original fix. But didn't, as you said, you would do it. Anyway, 
Thanks.

> then the discard fix becomes this one-liner:
>
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=999ae79ae7f853bb9e60
>e95753ebf8d1628e632a

Thanks
Nikanth
