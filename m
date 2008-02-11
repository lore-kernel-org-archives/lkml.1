Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbYBKLJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbYBKLJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYBKLJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:09:13 -0500
Received: from styx.suse.cz ([82.119.242.94]:60552 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752199AbYBKLJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:09:12 -0500
Date: Mon, 11 Feb 2008 12:09:10 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: udf regression: broken directory handling
Message-ID: <20080211110910.GB9622@duck.suse.cz>
References: <20080210104754.GH6737@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210104754.GH6737@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Sun 10-02-08 11:48:17, Marcin Slusarz wrote:
> Current mainline has a problem with reading file list.
> Simple ls prints only 2 out of 8 files on my testing DVD.
> Reverting your patch "udf: cleanup directory offset handling"
> (af793295bf9ee92660f5e77d337b0493cea3f9b9) fixes the problem.
  Thanks for testing! Do you have a way to create such UDF filesystem? For
the filesystems I've created it seems to work just fine...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
