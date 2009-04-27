Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZD0PYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZD0PYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZD0PYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:24:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:18148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZD0PYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=xWEXX0/yHwTHpqulOLXXGiSfPJx6Bxac+g5YpPp7JDK6iiFnLVvcOJTm7Fb4dfcbOd
         ITBWOrg6aDr3of1x2pDLvckDxechjkQcnvI/J1nb0RvMJjljm6qXUaxx9oEazRCTx1dP
         t39gG8qMrSluDnz7J3KDzkxuZV1Qyy6iYWYCE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [git patches] Staging: rtxxx0: cleanup and "dumb" merge
Date: Mon, 27 Apr 2009 17:28:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200904261759.20923.bzolnier@gmail.com> <20090426183954.GA18449@kroah.com>
In-Reply-To: <20090426183954.GA18449@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904271728.33140.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009 20:39:54 Greg KH wrote:
> On Sun, Apr 26, 2009 at 05:59:20PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > This patchset cleans up rt{286,287,307}0 drivers (66 KLOC removed) and then
> > "dumb" (i.e. rt3070 shares code with rt2870 by including rt2870's .c files
> > and depends on ifdefs to get the correct end result) merges them (142 KLOC
> > removed).  All in all 208 KLOC are gone and we now use the common code for
> > all three Ralink drivers.
> 
> Wonderful!
> 
> Were you able to test that this still works afterward?

I just used some semi-automatic verification of changes -- I scripted build
process with comparing sizes of resulting .o files so when they were different
I was re-auditing the given patch or (if re-audit didn't catch anything)
comparing corresponding .s files.  This of course doesn't provide us with
a complete proof that changes are correct but increases probability of such
outcome significantly. :)

The real testing with RT2860, RT2870 & RT3070 would be much welcomed...

Thanks,
Bart
