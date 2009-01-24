Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZAXSgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZAXSgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbZAXSgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:36:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:19606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZAXSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:36:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pzHlV6Z/7OOJBLImxll4fMeZCpTJ1eXJQ7/RRVs2GleUzc4kFJBzyHdzXO02/Pf8sW
         RNKXlrSmv/QdInzp0Nz2/2Di6ipcAkyqSfazWwsYLo9LHQkklUB6AGP4mhM1mPiDftoF
         CaUYmvXZjrD2yM2FMPMtYFgmZoIZnZZ1YGJM4=
Date: Sat, 24 Jan 2009 21:42:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: usr/include/linux/reiserfs_fs.h is having lot of KERNEL data
Message-ID: <20090124184216.GA7559@x200.localdomain>
References: <1232465242.3088.25.camel@localhost.localdomain> <1232778934.10414.4.camel@localhost.localdomain> <20090124073236.GA6166@x200.localdomain> <20090124074313.GA31882@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090124074313.GA31882@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 08:43:13AM +0100, Sam Ravnborg wrote:
> > >  
> > > -/* debug levels.  Right now, CONFIG_REISERFS_CHECK means print all debug
> > > -** messages.
> > > -*/
> > > +/* debug levels.  Right now, REISERFS_CHECK means print all debug messages */
> > 
> > Whoa, fix the tool!
> 
> This comment does not make sense in userspace so the tool was right - no?

Well, one could argue why tool pays attention to comments.
Anyway, this file requires line-by-line checking and making sure reiserfstools
continues to build.
