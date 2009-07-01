Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZGABnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZGABnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZGABnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:43:43 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:31921 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752342AbZGABnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:43:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zEPUrpZ5bYcuNggrOU0GeY8/2AFMeGuHHFwHrScuOtXLSQuHGt8toYW8DBaYAy5DB3aNXwtvAABiXHaQ446aOKBykPtJI5D42ECkeThc5akGGqOF1zUGEUbWUcOZavpa/gaCQAB3krw3/E3juYkwCBnSFQq2giFB8wz8zzgmJfA=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: pom0jfIVM1ldaZ8YeKLnm4kzpjmPNS_1sF.MAgK78wDCDrcmNRlfTfryq7Dz1Dym6FFhJnK3pcEOJSZPheunyjpo42sJjIrtnNDrUcEjcmAn15q8DdGpuhcWLIkodzDAGdZFP6xVhS3hryrIoUAAO8mVDMz_QgARw4CKmBK7p9n9VUoyxRVumHXux41ZXp.A8FLcNP.rlN6LYdgVeadQoEAX68V8m5zfSuyibGqJGpIwoPP5o9dxuSDsoffClBmevsz4SzN8FXSFFninIpSuTOiKwx83SWKF5AIoThYvHxpYvOI7Dnyiqf.LfODnABo3sbXcttrBBpkyCJaT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpiolib: allow exported GPIO nodes to be named using sysfs links
Date: Tue, 30 Jun 2009 18:43:22 -0700
User-Agent: KMail/1.9.10
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, linux-kernel@vger.kernel.org
References: <1244711943-15364-1-git-send-email-ext-jani.1.nikula@nokia.com> <20090622122547.bc672764.akpm@linux-foundation.org>
In-Reply-To: <20090622122547.bc672764.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301843.22646.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Andrew Morton wrote:
> On Thu, 11 Jun 2009 12:19:03 +0300
> Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> 
> > +int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
> > +{
> > +	struct gpio_desc	*desc;
> > +	int			status = -EINVAL;
> > +
> > +	BUG_ON(dev == NULL);
> > +	BUG_ON(name == NULL);
> 
> We usually don't bother with these assertions.  If the kernel will
> reliably oops if one of these is NULL, then that provides the same
> information anyway.

Yeah, it'd be better to remove those BUG_ON() things before this goes upstream...

