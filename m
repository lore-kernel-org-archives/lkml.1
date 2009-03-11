Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbZCKUiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbZCKUiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZCKUh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:37:56 -0400
Received: from po-out-1718.google.com ([72.14.252.156]:57107 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZCKUhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:37:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=t0L5NRP54ohHFJMjDFQROxvw3ieEvXp9yocb5zdoRgUtBiHxO27jqIjr1QUsdFGMj/
         epf1IXW8wRay7W+k/itWD4ACkNdEeHIBQLYnI6fWPKaSTRuVz6x0V3aDxwMAxDi3HaY9
         UPnM6skXqaGm4gAGM2xZy3BIGdGng1iWNyUM0=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <49B70A21.7070400@gmail.com>
References: <49B70A21.7070400@gmail.com>
Date: Thu, 12 Mar 2009 09:37:52 +1300
Message-ID: <cfd18e0f0903111337l7d423903t70afee6e5a987bfa@mail.gmail.com>
Subject: Re: [patch] MAINTAINERS: downgrade support for man-pages
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Looks as though vger didn't like my long CC list, and didn't carry
the message to the lists, so resending a slightly edited version to
just the lists.]

---------- Forwarded message ----------
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Wed, Mar 11, 2009 at 1:47 PM
Subject: [patch] MAINTAINERS: downgrade support for man-pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Linus Torvalds
<torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
Davide Libenzi <davidel@xmailserver.org>, Jim Zemlin
<jzemlin@linux-foundation.org>, Randy Dunlap <rdunlap@xenotime.net>,
Oleg Nesterov <oleg@tv-sign.ru>, Arnd Bergmann <arndb@de.ibm.com>,
Jeff Licquia <licquia@linux-foundation.org>, David Miller
<davem@davemloft.net>, Stephen Hemminger
<shemminger@linux-foundation.org>, Mats Wichmann
<mats.d.wichmann@intel.com>, Roland McGrath <roland@redhat.com>,
Ulrich Drepper <drepper@redhat.com>, Petr Baudis <pasky@suse.cz>, "H.
Peter Anvin" <hpa@zytor.com>, Theodore T'so <tytso@mit.edu>, James
Bottomley <James.Bottomley@hansenpartnership.com>, Ulrich Drepper
<drepper@redhat.com>, Christoph Hellwig <hch@lst.de>, Alain Portal
<alain.portal@univ-montp2.fr>, Greg KH <gregkh@suse.de>, Andi Kleen
<andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>, Andries
Brouwer <Andries.Brouwer@cwi.nl>, hohndel@infradead.org,
"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
linux-api@vger.kernel.org


Hi Andrew,

Unfortunately, Linux Foundation funding for my work
on man-pages/testing/doc under the auspices of the
LF documentation fellowship ran out a
short while ago (after earlier attempts to seek funding,
only Google stepped forward with a bit of further
funding for the position), so the patch below
acknowledges something closer to reality.

There will (probably very) soon be a further
downgrade from "Maintained" to "Odd Fixes" or "Orphan",
unless some funding miracle occurs.  So, if anyone is
looking to become man-pages maintainer, there may soon be
an opening (okay, don't trample me in the rush ;-).)

Cheers,

Michael

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c2ca1d..61aeb5a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1469,8 +1469,6 @@ L:        linux-acpi@vger.kernel.org
 S:     Supported

 DOCUMENTATION (/Documentation directory)
-P:     Michael Kerrisk
-M:     mtk.manpages@gmail.com
 P:     Randy Dunlap
 M:     rdunlap@xenotime.net
 L:     linux-doc@vger.kernel.org
@@ -2879,7 +2877,7 @@ P:        Michael Kerrisk
 M:     mtk.manpages@gmail.com
 W:     http://www.kernel.org/doc/man-pages
 L:     linux-man@vger.kernel.org
-S:     Supported
+S:     Maintained

 MARVELL LIBERTAS WIRELESS DRIVER
 P:     Dan Williams




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
