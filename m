Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbZACDXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbZACDXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbZACDXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:23:07 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44355 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbZACDXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:23:06 -0500
Date: Sat, 3 Jan 2009 03:22:42 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
       Christoph Hellwig <hch@infradead.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090103032242.GA2872@shareable.org>
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org> <200901020656.32013.rob@landley.net> <20090102140409.GA4758@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102140409.GA4758@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> perl is actually quite portable.

Portability aside, Perl has another fun issue.  The number of times
I've had a Perl script break when copied to a newer system which had a
newer version of Perl is... noticable.

> I'd also suggest explicitly add a reminder to the shell scripts'
> comments to avoid bashisms for maximum portability, to remind
> developers in the future who might try to change the shell scripts
> to watch out for portability issues.

You can force Bash into POSIX mode if that's helpful.

-- Jamie
