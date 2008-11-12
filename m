Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYKLNzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYKLNzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 08:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYKLNzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 08:55:04 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:48225 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYKLNzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 08:55:02 -0500
Date: Wed, 12 Nov 2008 13:54:59 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Dotan Barak <dotanba@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl print the line twice when trailing statements in
	the same line
Message-ID: <20081112135459.GC8302@shadowen.org>
References: <200810202051.38694.dotanba@gmail.com> <20081031082414.GD26593@brain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031082414.GD26593@brain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 08:24:14AM +0000, Andy Whitcroft wrote:
> On Mon, Oct 20, 2008 at 08:51:38PM +0200, Dotan Barak wrote:
> > Hi.
> > 
> > I executed checkpatch.pl version 0.24 on a file and i noticed that when
> > a tailing statement is being declared at the same line with "while, checkpatch
> > prints the erroneous line twice.
> > 
> > Here is an example of the output:
> > 
> > ERROR: trailing statements should be on next line
> > #651: FILE: idbm.c:651:
> > +               while (*nl && isspace(c = *nl)) nl++;
> > +               while (*nl && isspace(c = *nl)) nl++;
> > 
> > Is this is the expected behavior?
> 
> No that would definintaly not be expected.  Will add it to my TODO list.

Ok, this is now fixed up and should be in my next batch of updates.

-apw
