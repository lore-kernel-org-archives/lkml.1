Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZAEMa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZAEMa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZAEMaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:30:20 -0500
Received: from ns.firmix.at ([62.141.48.66]:4892 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZAEMaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:30:18 -0500
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with
	kernel/timeconst.sh
From: Bernd Petrovitsch <bernd@firmix.at>
To: Rob Landley <rob@landley.net>
Cc: Jamie Lokier <jamie@shareable.org>, Valdis.Kletnieks@vt.edu,
       Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <200901042250.36847.rob@landley.net>
References: <200901020207.30359.rob@landley.net>
	 <20090104221356.GA32357@shareable.org>
	 <1231114530.3310.6.camel@gimli.at.home>
	 <200901042250.36847.rob@landley.net>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 05 Jan 2009 13:29:11 +0100
Message-Id: <1231158551.3326.82.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.102 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.102 required=5
X-Spam-Score: -1.102 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Son, 2009-01-04 at 22:50 -0600, Rob Landley wrote:
> On Sunday 04 January 2009 18:15:30 Bernd Petrovitsch wrote:
[...]
> > ACK. A bash can IMHO be expected. Even going for `dash` is IMHO somewhat
> > too extreme.
> 
> I have yet to encounter a system that uses dash _without_ bash.  (All ubuntu 

Hmm, should be doable with a chroot environment quite cheap and simple.

> variants, even jeos, install bash by default.  They moved the /bin/sh symlink 

Yes, I know (small) embedded systems that have a bash (and not "only"
one of busybox shells). It eases writing somewhat fast shell scripts
without the need for lots of fork()s+exec()s too .....

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

