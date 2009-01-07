Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbZAGTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbZAGTlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbZAGTlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:41:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761332AbZAGTk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:40:59 -0500
Date: Wed, 7 Jan 2009 11:38:46 -0800
From: Greg KH <gregkh@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 06/60] sysfs: clarify SYSFS_DEPRECATED help text
Message-ID: <20090107193846.GB19027@suse.de>
References: <20090106221123.GA32689@kroah.com> <1231279939-32728-6-git-send-email-gregkh@suse.de> <18788.29727.163564.90030@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18788.29727.163564.90030@harpo.it.uu.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 10:21:35AM +0100, Mikael Pettersson wrote:
> Greg Kroah-Hartman writes:
>  > From: Kay Sievers <kay.sievers@vrfy.org>
>  > +	  This option is not a pure compatibility option that can
>  > +	  be safely enabled on newer distributions. It will change the
>  > +	  layout of sysfs to the non-extensible deprecated version,
>  > +	  and disable some features, which can not be exported without
>  > +	  confusing older userspace tools. Since 2007/2008 all major
>  > +	  distributions do not enable this option, and ship no tools which
>  > +	  depend on the deprecated layout or this option.
>  > +
>  > +	  If you are using a new kernel on an older distribution, or use
>  > +	  older userspace tools, you might need to say Y here. Do not say Y,
>  > +	  if the original kernel, that came with your distribution, has
>  > +	  this option set to N.
> 
> Instead of making vague references to "older" tools, could someone
> please make a list of the major tools that depend on sysfs, and the
> minimal/oldest versions needed for the non-deprecated layout?

Patches to do so are gladly welcome, but it might be a bit difficult as
spelunking through old distros isn't exactly the most fun thing to do :)

In short, any distro released in 2008 is fine, for 2007, you should also
be fine, but you might want to be safe.  anything older than that, you
should set this value to Y.

hope this helps,

greg k-h
