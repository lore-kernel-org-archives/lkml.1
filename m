Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbYBFOTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbYBFOTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYBFOTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:19:44 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:21876 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYBFOTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:19:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ky+ndmpHiwC2ACOo8xSsBJSLnkh2f2Aqd0j2nRPHe3EQ6caLFUzAmc7BmI48GsajPVTunucqIlkm01QjIhDSYiavY9EKUEoO8ziXS6F17S51G76fSp5BHTr6jJb8KURjXGA4XpdtsdRnLAB9nzGKa/a7Ja4PEXBS9HRv3+1Zucg=
Date: Wed, 6 Feb 2008 09:19:39 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.25-rc0
Message-ID: <20080206091744.ZZRA012@mailhub.coreip.homeip.net>
References: <200802060108.31644.dtor@insightbb.com> <20080205223242.f444fad6.akpm@linux-foundation.org> <200802060149.50879.dtor@insightbb.com> <20080206075635.GA6354@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206075635.GA6354@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 08:56:35AM +0100, Sam Ravnborg wrote:
> >  
> > > 
> > > 
> > > 
> > > i8042_platform_init():
> > > 
> > > +#if defined(__i386__) || defined(__x86_64__)
> > > 
> > > use #ifdef CONFIG_X86?
> > > 
> > 
> > I considered it but above was tested and in line with the style of the
> > rest of the file...
> Then please change the rest of the file so it is consistent
> with the usual style to use our CONFIG_ symbols for
> conditionals like the above.
> 

Will do in the next update. The #if defined(__i386__) code predates
CONFIG_X86_32 and was not updated when this symbol became available.

Overall, do you want me to redo the pull or is it still acceptable?

-- 
Dmitry
