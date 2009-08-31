Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZHaMPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZHaMPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZHaMPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:15:49 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50347 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbZHaMPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:15:48 -0400
Date: Mon, 31 Aug 2009 14:15:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: i2c tree build failure
Message-ID: <20090831141546.6c52c7fb@hyperion.delvare>
In-Reply-To: <20090831215905.caadce2f.sfr@canb.auug.org.au>
References: <20090831111935.5059565b.sfr@canb.auug.org.au>
	<20090831120449.3f64aa74@hyperion.delvare>
	<20090831210335.f382d7ff.sfr@canb.auug.org.au>
	<20090831131647.3f609ad4@hyperion.delvare>
	<20090831215905.caadce2f.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009 21:59:05 +1000, Stephen Rothwell wrote:
> On Mon, 31 Aug 2009 13:16:47 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > I am also surprised that I would have to tell you. What is the purpose
> > of the NEXT_BASE tag if you do not check for dependencies automatically?
> 
> I use the tag to choose the base when I import the quilt series into git.
> So far I have not needed to automate the ordering of the imports.
> 
> > Anyway, if you say git can deal with duplicate patches OK, then I think
> > I'll simply re-add the patch on my end. But I do not have a strong
> > opinion on this either, so if you prefer clean dependencies and
> > ordering without duplicate patches, it is just as easy for me to leave
> > the redundant patch out and restore the NEXT_BASE tag.
> 
> I prefer less dependencies (so you could put the patch back in), however,
> that means if Greg changes the patch, then we will have two slightly
> different versions to merge.  I can cope with that as well.

I've made sure my patch has the same name as Greg's, to make it easier
for you to spot duplicates.

> Just readd the patch :-)

OK, done. Hopefully the next merge window is coming soon now anyway, and
then the trouble with this specific patch will be solved.

-- 
Jean Delvare
