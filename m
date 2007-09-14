Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbXINQgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbXINQgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbXINQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:36:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39637 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbXINQgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:36:12 -0400
Date: Fri, 14 Sep 2007 17:36:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [patch 1/4] Introduce pathput
Message-ID: <20070914163611.GA30469@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
	John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
	Erez Zadok <ezk@cs.sunysb.edu>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de> <20070808193209.GA31354@infradead.org> <20070810142208.827949199@suse.de> <20070810143846.804017666@suse.de> <20070829190710.GA28028@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829190710.GA28028@infradead.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 08:07:10PM +0100, Christoph Hellwig wrote:
> > * Switch from path_release_on_umount(nd) to pathput_on_umount(&nd->path).
> > 
> > * Rename dput_path() to pathput_conditional().
> 
> The introduction of pathput is fine we me.  The removal of path_release
> doesn't make much sense.  We have tons of invocations of exactly that
> patter, and having keeping path_release for that makes a lot of sense.

After some private discussion on this I think I was overruled, so feel
free to keep that change.  Al also suggested to rename the things
to path_get/path_put which makes sense.

Any chance you could respin the series with the review comments addressed
so that there is a chance to get it into 2.6.24?
