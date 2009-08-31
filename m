Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZHaLQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZHaLQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbZHaLQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:16:48 -0400
Received: from bamako.nerim.net ([62.4.17.28]:53066 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZHaLQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:16:47 -0400
Date: Mon, 31 Aug 2009 13:16:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: i2c tree build failure
Message-ID: <20090831131647.3f609ad4@hyperion.delvare>
In-Reply-To: <20090831210335.f382d7ff.sfr@canb.auug.org.au>
References: <20090831111935.5059565b.sfr@canb.auug.org.au>
	<20090831120449.3f64aa74@hyperion.delvare>
	<20090831210335.f382d7ff.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 31 Aug 2009 21:03:35 +1000, Stephen Rothwell wrote:
> On Mon, 31 Aug 2009 12:04:49 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > 
> > These are caused by the fact that I moved the patch adding
> > class_compat_create_link() and friends out of the NEXT_PATCHES section.
> > I did so because Greg KH (Cc'd) added this patch to his driver-core
> > patch set, which I thought was part of linux-next. I simply didn't want
> > to apply the same patch twice.
> 
> It doesn't really matter if the same patch appears twice - git usually
> copes quite well.  Also I can tell and I (usually) don't bother
> commenting on it.
> 
> > To clarify the dependency, I added the following to my series.conf:
> > 
> > # NEXT_BASE driver-core.current
> > 
> > but apparently it didn't work as intended.
> > 
> > Greg, please clarify whether the patch in question
> > (driver-core-add-support-for-compatibility-classes.patch) is pushed to
> > linux-next or not.
> > 
> > Stephen, if my dependency tag is not correct, please tell me how to fix
> > it.
> 
> It was fine, except that Greg has that patch in the driver-core series
> (not driver-core.current).

OK, thanks for the clarification. I did not notice Greg had split some
of his trees that way. Makes sense.

> It you decide to leave that patch out and
> change the dependency, please let me know as I will then have to merge
> your tree after Greg's (it is currently earlier.

Regardless of what I do, I think it would make sense to merge
driver-core before driver subsystem trees. I would insert if before pci.

I am also surprised that I would have to tell you. What is the purpose
of the NEXT_BASE tag if you do not check for dependencies automatically?

Anyway, if you say git can deal with duplicate patches OK, then I think
I'll simply re-add the patch on my end. But I do not have a strong
opinion on this either, so if you prefer clean dependencies and
ordering without duplicate patches, it is just as easy for me to leave
the redundant patch out and restore the NEXT_BASE tag.

Thanks,
-- 
Jean Delvare
