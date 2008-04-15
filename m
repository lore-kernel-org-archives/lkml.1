Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbYDOJKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbYDOJKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbYDOJKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:10:39 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27446 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753075AbYDOJKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:10:38 -0400
Message-ID: <480470C6.6050908@panasas.com>
Date: Tue, 15 Apr 2008 12:09:26 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andy Whitcroft <apw@shadowen.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SL Baur <steve@xemacs.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] checkpatch: relax spacing and line length
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com> <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com> <20080412002652.GM9785@ZenIV.linux.org.uk> <4801D82C.7000901@panasas.com> <20080413151845.GP9785@ZenIV.linux.org.uk>
In-Reply-To: <20080413151845.GP9785@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2008 09:09:31.0700 (UTC) FILETIME=[6A80A740:01C89ED8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr. 13, 2008, 18:18 +0300, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Sun, Apr 13, 2008 at 12:53:48PM +0300, Benny Halevy wrote:
> 
>>> Sorry.  I'm not going to change perfectly working editing habits *or* to patch
>> That's working well for you but apparently not so well for everybody else.
> 
> Nice turn of a phrase, that.
> 
>>> nvi to satisfy an annoying wunch of bankers.  HAND, GAFL.
>>> --
>> Thanks for the insightful and mature comment, Al.
> 
> Oh, for the...
> 
>> I really hate to spend more time on this topic but folks did find merits in it.
>> There's no need to change anybody's editing habits if we allow this indentation
>> style in the CodingStyle document and in checkpatch.pl in addition to the
>> existing convention.
> 
> "Allow" is such a nice word, isn't it?  Let's take a closer look:
> 	* nobody prohibits lines satisfying your constraints ("tabs only for
> indent level"), so "allowing" that is meaningless

Currently checkpatch.pl prints an error if I use 8 or more spaces in the
indentation string and Documentation/CodingStyle says:

"Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation"

Although CodingStyle and checkpatch just provide guidance and the final
word is the maintainer's I consider these recommendations as "disallowing",
or at least "discouraging". So did others that commented on patches I sent
in the past.  If that wasn't the case I wouldn't have come up with this
silly initiative in the first place.

> 	* "indentation style" in the above refers to editor settings.
> To "allow" that, you advocate prohibiting the lines _NOT_ satisfying your
> constraints.  Which, by definition, means extra work for people submitting
> patches, no matter how you spin it.

I'm certainly not advocating to prohibit the current indentation style,
just to relax the rules to allow a superset of it.

Basically, I'd like checkpatch to allow /^\+\t* *\S/
and, since Andy says that checkpatch knows "the indent to some degree",
it can warn if the number of leading tabs is smaller than that.

> 
> BTW, while we are talking about conventions, would you mind keeping lines
> in your mail shorter than 79 columns to avoid wraparounds in quoted text?
> Unlike your proposal, that one actually _is_ a common convention...

No, I don't mind.

[Though it is a bit of a pain to keep that when automatic wrapping of long
lines is turned off in my mail program so I can easily quote patches or
code snippets.]

Benny

