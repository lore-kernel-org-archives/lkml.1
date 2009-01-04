Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZADCXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZADCXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZADCXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:23:09 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45108
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZADCXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:23:08 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 20:23:04 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901020656.32013.rob@landley.net> <20090102140409.GA4758@mit.edu>
In-Reply-To: <20090102140409.GA4758@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901032023.05001.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 08:04:09 Theodore Tso wrote:
> Sounds like though modulo dealing with 64-bit arithmetic, your patches
> are mostly dash/POSIX.2 comformant, so you're probably mostly good on
> that front once you address the 32/64-bit issues.  I'd also suggest
> explicitly add a reminder to the shell scripts' comments to avoid
> bashisms for maximum portability, to remind developers in the future
> who might try to change the shell scripts to watch out for portability
> issues.

I changed the scripts to start with #!/bin/sh and retested under dash.

If scripts say #!/bin/sh when they actually need bash, or say #!/bin/bash when 
they work with dash, that should probably be fixed.

Rob
