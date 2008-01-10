Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYAJIer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYAJIer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYAJIej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:34:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40805 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYAJIei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:34:38 -0500
Date: Thu, 10 Jan 2008 08:34:25 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Alasdair G Kergon <agk@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com, viro@ftp.linux.org.uk
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080110083425.GA10745@infradead.org>
References: <20080108164015.GC31504@one.firstfloor.org> <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com> <1199909560.6245.67.camel@cinder.waste.org> <20080109224026.GA4039@agk.fab.redhat.com> <20080109224603.GH15612@one.firstfloor.org> <20080109224513.GF3510@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109224513.GF3510@agk.fab.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:45:13PM +0000, Alasdair G Kergon wrote:
> On Wed, Jan 09, 2008 at 11:46:03PM +0100, Andi Kleen wrote:
> > struct inode *inode = file->f_dentry->d_inode;
>  
> And oops if that's not defined?

For file_operations which we talk about here it always is defined.
Block_device is a different story, but it'll get a completely different
prototype soon with neither file nor inode passed to it.
