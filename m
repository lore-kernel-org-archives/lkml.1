Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZDWCZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZDWCZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 22:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZDWCZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 22:25:31 -0400
Received: from kroah.org ([198.145.64.141]:48194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZDWCZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 22:25:30 -0400
Date: Wed, 22 Apr 2009 19:08:24 -0700
From: Greg KH <greg@kroah.com>
To: fmhess@users.sourceforge.net
Cc: Roel Kluin <roel.kluin@gmail.com>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
       David Schleef <ds@schleef.org>
Subject: Re: staging: comedi: non working tests on unsigned cmd->convert_arg
Message-ID: <20090423020824.GA6083@kroah.com>
References: <49EDC792.60100@gmail.com> <20090422165049.GC19524@kroah.com> <200904221411.13851.fmhess@speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904221411.13851.fmhess@speakeasy.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 02:11:10PM -0400, Frank Mori Hess wrote:
> On Wednesday 22 April 2009, Greg KH wrote:
> > On Tue, Apr 21, 2009 at 03:18:10PM +0200, Roel Kluin wrote:
> > > vi drivers/staging/comedi/comedi.h +342
> > >
> > > and note that cmd->convert_arg in s626_ai_cmdtest() is unsigned.
> > > Should there maybe be a test:
> > >
> > > if (cmd->convert_src == TRIG_EXT && cmd->convert_arg > MAX)
> > >
> > > (and what should MAX be then?)
> >
> > I don't know.  Let's ask the comedi developers :)
> >
> > Frank, what do you think about this?
> 
> 
> It looks like there already is such a test, right below the useless one the 
> patch removes.

Ok, thanks for checking.  Roel, care to resend these patches then?

thanks,

greg k-h
