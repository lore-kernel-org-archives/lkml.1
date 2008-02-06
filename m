Return-Path: <linux-kernel-owner+w=401wt.eu-S1751903AbYBFLK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbYBFLK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYBFLKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:10:11 -0500
Received: from styx.suse.cz ([82.119.242.94]:44080 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751446AbYBFLKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:10:10 -0500
Date: Wed, 6 Feb 2008 12:10:08 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] udf: convert udf_stamp_to_time and
	udf_time_to_stamp to use timestamps
Message-ID: <20080206111008.GD12547@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <1202063771-18172-5-git-send-email-marcin.slusarz@gmail.com> <20080205155956.GI25464@duck.suse.cz> <20080205192153.GB6332@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205192153.GB6332@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-02-08 20:21:58, Marcin Slusarz wrote:
> On Tue, Feb 05, 2008 at 04:59:56PM +0100, Jan Kara wrote:
> > On Sun 03-02-08 19:36:09, marcin.slusarz@gmail.com wrote:
> > > kernel_timestamp type was almost unused - only callers of udf_stamp_to_time
> > > and udf_time_to_stamp used it, so let these functions handle endianness
> > > internally and don't clutter code with conversions
> >   OK, but please also rename the functions to something like
> > udf_disk_stamp_to_time() and udf_time_to_disk_stamp() so that the name
> > suggests that it internally handles endianess...
> Ok, should I redo this patch or create separate patch on top of it?
  Please, just redo this one. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
