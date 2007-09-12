Return-Path: <linux-kernel-owner+w=401wt.eu-S971821AbXILSXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971821AbXILSXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965052AbXILSXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:23:11 -0400
Received: from ns.firmix.at ([62.141.48.66]:60753 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965613AbXILSXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:23:10 -0400
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dan Stromberg <dstromberglists@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070912181621.GA18688@uranus.ravnborg.org>
References: <pan.2007.09.12.16.13.41.195991@gmail.com>
	 <20070912170529.GA18311@uranus.ravnborg.org>
	 <1189617081.31502.78.camel@tara.firmix.at>
	 <20070912175116.GB18311@uranus.ravnborg.org>
	 <1189620642.31502.104.camel@tara.firmix.at>
	 <20070912181621.GA18688@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 12 Sep 2007 20:23:04 +0200
Message-Id: <1189621385.31502.111.camel@tara.firmix.at>
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

On Wed, 2007-09-12 at 20:16 +0200, Sam Ravnborg wrote:
> > 
> > But we are talking[0] about a kernel-source-$VERSION.$ARCH.rpm's which
> > contain
> > the kernel sources (read: lots of .c and .h files, etc.) - including a
> > matching
> > .config and after `make oldconfig` - so that one can build out-of-tree
> > modules
> > after installing it with "KSRC=" (or whatever the Makefile parameter is
> > usually called).
> You need certain things of the kernel built before you can build
> external modules (if they use a sane build approach).
> Just including the .config with the kernel source is far from enough.

ACK.
That all must be done/prepared correctly for the kernel-source-*.rpm.
And nobody said it is trivial or easy.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


