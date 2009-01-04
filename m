Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZADE6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZADE6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 23:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZADE5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 23:57:53 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60028
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZADE5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 23:57:52 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: markus.heidelberg@web.de
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 22:57:48 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: "Leon Woestenberg" <leon.woestenberg@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901032054.00018.rob@landley.net> <200901040438.14610.markus.heidelberg@web.de>
In-Reply-To: <200901040438.14610.markus.heidelberg@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901032257.48854.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 21:38:13 Markus Heidelberg wrote:
> Rob Landley, 04.01.2009:
> Now that you mention this the second time, I have to ask where you have
> this information from. Since I use Gentoo, I was always able to compile
> OpenOffice (version 1, 2 and now 3) myself.

The gentoo panel last OLS.  (Either a BOF or a tutorial, I don't remember 
which.)  It's still _possible_ to build it from source, but they created a 
separate "openoffice-bin" package for the sole purpose of _not_ compiling it 
from source, and it's what they recommend installing.

> At the same time, it was always possible to use prebuilt packages as an
> alternative - the same way as it is possible for a few other packages
> (Firefox, Thunderbird, Seamonkey, maybe more). But AFAIK compiling from
> source is still the preferred method.

Apparently not for Open Office.

First hit googling "gentoo openoffice install":
http://grokdoc.net/index.php/Gentoo-OpenOffice.org

The next two hits are bug tracker entries, and the one after that:
http://www.linuxforums.org/forum/gentoo-linux-help/71086-installing-
openoffice-question.html

Contains this cut and paste from emerge output:

These are the packages that would be merged, in order:

Calculating dependencies
!!! All ebuilds that could satisfy "openoffice" have been masked.
!!! One of the following masked packages is required to complete your request:
- app-office/openoffice-2.0.4_rc1-r1 (masked by: package.mask, package.mask, 
~am d64 keyword)
# 2005/10/24 Simon Stelling <blubb@gentoo.org>
# Don't even try to compile openoffice-2.x, it won't work.

But not to go too far down this rathole, I'm just using openoffice as an 
example here.  If you want to talk about it more, take it off list please.

> Markus

Rob
