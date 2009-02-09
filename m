Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZBIIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZBIIlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 03:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZBIIlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 03:41:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46941 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZBIIlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 03:41:15 -0500
Date: Mon, 9 Feb 2009 08:41:12 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl is getting too slow
Message-ID: <20090209084112.GB32740@shadowen.org>
References: <20090131185507.GA3280@kroah.com> <20090131210220.GA25811@shadowen.org> <1233449877.5903.48.camel@desktop> <20090201044614.GA8589@kroah.com> <1233510446.5903.87.camel@desktop> <20090203051632.GA13289@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203051632.GA13289@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 09:16:32PM -0800, Greg KH wrote:
> On Sun, Feb 01, 2009 at 09:47:26AM -0800, Daniel Walker wrote:
> > 
> > 
> > I found a little more on this.. It seems the problem with #define lines
> > only causes a few extra seconds delay .. I found another issue C99 style
> > comments.
> > 
> > On line 642 your file has this line,
> > 
> > // For the UART control registers, the application number need to be Or'ed
> > 
> > The quote in Or'ed causes checkpatch to treat the rest of the file as a
> > big string that never closes. Or that's my impression. The delay is
> > caused in the same way as the define delay. In order to check one line
> > in the file the rest of the file is scanned.
> > 
> > The fix below increased the number of errors found too.
> > 
> > total: 347 errors, 278 warnings, 3932 lines checked
> 
> Nice, this looks good to me, thanks for figuring this out.
> 
> Andy, any thoughts?

Sorry for the delay, been out of the office this week.  Will check these
two out.

-apw
