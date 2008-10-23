Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbYJWUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbYJWUvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYJWUvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:51:20 -0400
Received: from kroah.org ([198.145.64.141]:51420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752944AbYJWUvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:51:19 -0400
Date: Thu, 23 Oct 2008 13:46:28 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?utf-8?B?0JXQstCz0LXQvdC40Lkg0JzQsNC90LDRh9C60LjQvQ==?= 
	<sfstudio@mail.ru>,
       gorcunov@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] patch to 2.6.27 fix build rpm
Message-ID: <20081023204628.GC17600@kroah.com>
References: <20081015172412.GB20222@localhost> <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru> <20081015184652.3a935e6f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081015184652.3a935e6f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 06:46:52PM +0100, Alan Cox wrote:
> On Wed, 15 Oct 2008 23:37:26 +0600
> Евгений Маначкин  <sfstudio@mail.ru> wrote:
> 
> > From: Evgeniy Manachkin <sfstudio@mail.ru>
> > Subject: [PATCH] mkspec - fix build rpm
> > 
> > This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel. This is regression in 2.6.27. 2.6.26 make rpm work good.
> > In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)." 
> > This is patch fix it this error.
> > 
> > Sorry my English.
> > 
> > Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>
> 
> Acked-by: Alan Cox <alan@redhat.com>
> 
> This should IMHO go straight into both upstream and 2.6.27.x as it is a
> regression fix.

This doesn't seem to have gone into Linus's tree yet, can someone please
resend it?

Also be sure to cc: stable@kernel.org on this patch as well.

thanks,

greg k-h
