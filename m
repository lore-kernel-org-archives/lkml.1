Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYDTJ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYDTJ7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 05:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYDTJ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 05:58:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:18055 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYDTJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 05:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bdi26/R3saZ68bp/4+ShXKh7OqPybsvTVfVeSSznL5uVeNIOs6Gpk3UII6uIU/+OsdyVjr4DiTsBAHOV1M32K6on3LZSQxZJgPJZW/pc5MRHpsxQV0i4S3w47b92xcManyl2awwDb6QruOjgF7o/yWAmUKRpePYgMymdXv/PC6g=
Date: Sun, 20 Apr 2008 11:57:22 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/8] omfs: add inode routines
Message-ID: <20080420095718.GA6079@joi>
References: <1208637457-24969-4-git-send-email-me@bobcopeland.com> <20080419212842.GA7888@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419212842.GA7888@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 11:28:42PM +0200, Marcin Slusarz wrote:
> > +static void set_block_shift(struct omfs_sb_info *sbi)
> > +{
> > +	unsigned int scale = sbi->s_blocksize / sbi->s_sys_blocksize;
> > +	sbi->s_block_shift = 0;
> > +	for (scale >>= 1; scale; scale >>= 1)
> > +		sbi->s_block_shift++;
> > +}
> isn't it get_bitmask_order(scale - 1)?

I mean get_bitmask_order(scale >> 1) ;)

Marcin

