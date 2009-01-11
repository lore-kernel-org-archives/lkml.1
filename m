Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZAKMre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZAKMre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZAKMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:47:23 -0500
Received: from ns.firmix.at ([62.141.48.66]:3375 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZAKMrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:47:22 -0500
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
From: Bernd Petrovitsch <bernd@firmix.at>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Rob Landley <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
References: <200901020207.30359.rob@landley.net>
	 <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com>
	 <495FEEAF.5020005@zytor.com> <200901032006.47652.rob@landley.net>
	 <20090104030619.GA21466@linux-sh.org>
	 <c384c5ea0901040223l6e53f041s9f7cdea20c9d1d8d@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Sun, 11 Jan 2009 13:45:39 +0100
Message-Id: <1231677939.3517.5.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.096 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.096 required=5
X-Spam-Score: -1.096 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Son, 2009-01-04 at 11:23 +0100, Leon Woestenberg wrote:
[...]
> On Sun, Jan 4, 2009 at 4:06 AM, Paul Mundt <lethal@linux-sh.org> wrote:
[...]

I'm ignoring the "cross-compile perl" issue - haven't tried it for
years.

> 5. Tool *version* dependency is hard to get right. When cross-building
> 30 software packages all requiring native perl, we probably need to
> build a few versions of perl (native), one for each set of packages.

perl is IMHO special (and quite different to others - including
especially autotools): perl5 is used widely enough so that "one somewhat
recent version" should cover all of 30 software packages.
The hard part are the CPAN modules and their versions which are really a
PITA.
As long as you don't use modules from CPAN, "perl5" should be specific
enough.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

