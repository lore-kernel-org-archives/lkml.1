Return-Path: <linux-kernel-owner+w=401wt.eu-S968508AbXILSLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968508AbXILSLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765584AbXILSKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:10:51 -0400
Received: from ns.firmix.at ([62.141.48.66]:60724 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764924AbXILSKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:10:51 -0400
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070912175116.GB18311@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
	 <20070912170529.GA18311@uranus.ravnborg.org>
	 <1189617081.31502.78.camel@tara.firmix.at>
	 <20070912175116.GB18311@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 12 Sep 2007 20:10:42 +0200
Message-Id: <1189620642.31502.104.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.315 required=5
X-Spam-Score: -2.315 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 19:51 +0200, Sam Ravnborg wrote:
> On Wed, Sep 12, 2007 at 07:11:21PM +0200, Bernd Petrovitsch wrote:
> > On Wed, 2007-09-12 at 19:05 +0200, Sam Ravnborg wrote:
> > [....]
> > > Being rpm ignorant I do not know what the expected content of a kernel-source RPM
> > > are but this is the available targets for kernel packaging (from make help):
> > 
> > The kernel-source including all patches and configured as usually to be
> > found under
> > /usr/src/linux-$VERSION (or so). One needs that for e.g. external
> > modules.
> For external modules you need a fully build kernel which may be 
> clean up by "make clean".
> Thats not the same as a source RPM as per my understanding.

Yes, if "source RPM" means files named like "kernel-$VERSION.src.rpm".

But we are talking[0] about a kernel-source-$VERSION.$ARCH.rpm's which
contain
the kernel sources (read: lots of .c and .h files, etc.) - including a
matching
.config and after `make oldconfig` - so that one can build out-of-tree
modules
after installing it with "KSRC=" (or whatever the Makefile parameter is
usually called).
And such kernel-source-$VERSION.$ARCH.rpm's may/will/should fall also
out
of a rebuild of a kernel-$VERSION.src.rpm.

	Bernd

[0]: And Dan pointed it out explicitly right at the start BTW.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


