Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZBCFSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZBCFSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBCFSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:18:31 -0500
Received: from kroah.org ([198.145.64.141]:41041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751347AbZBCFSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:18:30 -0500
Date: Mon, 2 Feb 2009 21:16:32 -0800
From: Greg KH <greg@kroah.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl is getting too slow
Message-ID: <20090203051632.GA13289@kroah.com>
References: <20090131185507.GA3280@kroah.com> <20090131210220.GA25811@shadowen.org> <1233449877.5903.48.camel@desktop> <20090201044614.GA8589@kroah.com> <1233510446.5903.87.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233510446.5903.87.camel@desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 01, 2009 at 09:47:26AM -0800, Daniel Walker wrote:
> 
> 
> I found a little more on this.. It seems the problem with #define lines
> only causes a few extra seconds delay .. I found another issue C99 style
> comments.
> 
> On line 642 your file has this line,
> 
> // For the UART control registers, the application number need to be Or'ed
> 
> The quote in Or'ed causes checkpatch to treat the rest of the file as a
> big string that never closes. Or that's my impression. The delay is
> caused in the same way as the define delay. In order to check one line
> in the file the rest of the file is scanned.
> 
> The fix below increased the number of errors found too.
> 
> total: 347 errors, 278 warnings, 3932 lines checked

Nice, this looks good to me, thanks for figuring this out.

Andy, any thoughts?

greg k-h
