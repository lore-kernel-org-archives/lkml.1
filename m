Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0BQFlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 00:41:45 -0500
Received: from 1wt.eu ([62.212.114.60]:56449 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0BQFlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 00:41:44 -0500
Date: Wed, 17 Feb 2010 06:40:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: James Cloos <cloos@jhcloos.com>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100217054047.GF18216@1wt.eu>
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk> <20100214102308.1d1d6fff@hyperion.delvare> <20100214094940.GB17999@1wt.eu> <m3wrye9od4.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3wrye9od4.fsf@lugabout.jhcloos.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 04:31:59PM -0500, James Cloos wrote:
> >>>>> "W" == Willy Tarreau <w@1wt.eu> writes:
> 
> W> Well, I personally like to be able to simply run "less patch-2.6.27.45.gz"
> W> and have it transparently uncompressed and dumped on my terminal. It
> W> doesn't do that on bz2. We could find multiple examples.
> 
> It does here, and lzma & xz, too.  And has since just days after Lasse
> annouced that the new name would be xz.
> 
> Your LESSOPEN controls that, and can be easily coded to support any archive.

Just checked and I found it funny to see that patch-2.6.1.bz2 is not
correctly opened while 2.6.27.45.bz2 is. Maybe some things have slightly
changed in the tools by that time and the output differs slightly. However
bzcat opens them both so the file is not corrupted.

This raises the point of the maturity of the tools BTW. GZ is mature,
BZ2 has become mature over the years, XZ is very recent and may still
be buggy at times. We'll only know that when people will complain that
they cannot open one file from time to time.

Willy

