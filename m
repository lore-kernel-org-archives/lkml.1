Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbXINHwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbXINHwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 03:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXINHwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 03:52:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXINHwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 03:52:37 -0400
Date: Fri, 14 Sep 2007 09:52:34 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] Add ELF note with Linux version
Message-ID: <20070914075234.GI30366@suse.de>
Mail-Followup-To: Jeremy Fitzhardinge <jeremy@goop.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dan Aloni <da-x@monatomic.org>
References: <20070904150018.GA4357@suse.de> <46DFD825.2020109@goop.org> <20070913144228.2efcd5d9.akpm@linux-foundation.org> <46E9B22B.1000002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E9B22B.1000002@goop.org>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge <jeremy@goop.org> [2007-09-13 23:56]:
> 
> > I'd like to know a little bit more about why this is needed, how it will be
> > used, etc.  And given that this feature is intended to improve life for
> > distributors, it would be nice to get some feedback from the appropriate
> > persons.
> 
> Hm, yes.  ELF notes don't appear in the bzImage, since it isn't an ELF
> file, so perhaps this doesn't satisfy the requirement.  It would help to
> have more detail.

the bzImage already contains the version (and much more, e.g. if the
kernel is relocatable, the command line length it accepts). See
Documentation/i386/boot.txt.



Thanks,
   Bernhard
