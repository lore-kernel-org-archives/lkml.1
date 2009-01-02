Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZABRuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZABRuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbZABRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:50:00 -0500
Received: from stoneboat.aleph1.co.uk ([80.68.88.63]:3020 "EHLO
	stoneboat.aleph1.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118AbZABRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:49:59 -0500
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 12:49:58 EST
Date: Fri, 2 Jan 2009 17:25:41 +0000
From: Wookey <wookey@wookware.org>
To: Embedded Linux mailing list <linux-embedded@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Message-ID: <20090102172540.GE8858@knossos.aleph1.co.uk>
Mail-Followup-To: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
	Paul Mundt <lethal@linux-sh.org>, Rob Landley <rob@landley.net>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <20090102095023.GA28078@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102095023.GA28078@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Aleph_One-MailScanner: Found to be clean
X-Aleph_One-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.6, required 6, autolearn=not spam, BAYES_00 -2.60,
	NO_RELAYS -0.00)
X-Aleph_One-MailScanner-From: wookey@wookware.org
X-SA-Exim-Connect-IP: 213.165.225.113
X-SA-Exim-Mail-From: wookey@wookware.org
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on stoneboat.aleph1.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-02 18:50 +0900, Paul Mundt wrote:
> Your main reasons against inclusion of perl seem to be that there is no
> realistic expectation for target systems that will be self-hosting will
> have perl included, or the inherent complexity in maintaining a coherent
> cross compiling environment. Both of these things are issues with your
> own environment, and in no way are these representative of the embedded
> development community at large.

It may well be true that most embedded people cross-build kernels and
use native perl on a fat build box, but there are plenty of situations
where being able to build kernels without perl is useful. Given the
simplicitly of these patches I can't see any reason not to put them
in, and appreciate Rob's work on this.

And if cross-building perl is really easy, as some in this thread
claim, can someone fix the Debian packages to do it, because that
would be really useful (it appears to be of similar complexity to
cross-building gcc, requiring a 2-stage self-referential build). 

Wookey
-- 
Principal hats:  Balloonz - Toby Churchill - Aleph One - Debian
http://wookware.org/
