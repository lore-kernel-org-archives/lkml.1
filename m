Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYCTCRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYCTCRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbYCTCRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:17:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbYCTCRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:17:15 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
Date: Tue, 18 Mar 2008 16:32:43 -0400
User-Agent: KMail/1.9.9
Cc: =?utf-8?q?=C3=89ric_Piel?= <Eric.Piel@tremplin-utc.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <200803171327.16695.lenb@kernel.org> <1205858252.21619.233.camel@queen.suse.de>
In-Reply-To: <1205858252.21619.233.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803181632.44288.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > The initrd version of the DSDT override is really for one scenario.
> > Somebody who has a BIOS that even Windows can't deal with -- so
> > no amount of "Windows bug compatbility" will help Linux with it.

> No, this is for people getting involved in ACPI.
> Everybody thinks ACPI is that complicated..., but it's not.
> It's amazing how far people can debug ACPI bugs (yes, even people who
> "do not even know" how to compile a kernel) by simply analyzing the ASL
> BIOS code.

Thomas,
The justification above is what convinced me
that we should try to integrate this feature.
Further, although we failed in 2.6.25,
I think we should continue to try to get this capability integrated.

If you think it will be useful for additional purposes, that's great.
As you know, I'm somewhat skeptical, as I've seen huge mistakes such
as a database of modified BIOS images created and used when the users
have absolutely no idea what they're doing.  But we don't have to
agree on this to move forward.

thanks,
-Len
