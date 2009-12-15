Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbZLOVaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbZLOVaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761120AbZLOVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:30:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761106AbZLOVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:30:10 -0500
Date: Tue, 15 Dec 2009 22:30:05 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jerry Leo <jerryleo860202@gmail.com>, jack@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] quota: integer =?utf-8?Q?const?=
	=?utf-8?Q?ant_is_too_large_for_=E2=80=98long=E2=80=99?= type in
Message-ID: <20091215213005.GB9554@quack.suse.cz>
References: <6304b52b0912150527v48056ccam8d1c318bcd7e085b@mail.gmail.com>
 <1260890654.18538.123.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260890654.18538.123.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-12-09 07:24:14, Joe Perches wrote:
> On Tue, 2009-12-15 at 21:27 +0800, Jerry Leo wrote:
> > -               info->dqi_maxblimit = 0xffffffffffffffff;       /* 2^64-1 */
> > -               info->dqi_maxilimit = 0xffffffffffffffff;
> > +               info->dqi_maxblimit = 0xFFFFFFFFFFFFFFFFLL;     /* 2^64-1 */
> > +               info->dqi_maxilimit = 0xFFFFFFFFFFFFFFFFLL;
> 
> ULLONG_MAX?
  Not quite - I want it to really be 2^64 - 1 (on disk type is u64)
so ULLONG_MAX would be confusing IMHO.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
