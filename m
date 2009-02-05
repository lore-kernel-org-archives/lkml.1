Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZBEPH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZBEPH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbZBEPHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:07:40 -0500
Received: from SOUTH-STATION-ANNEX.MIT.EDU ([18.72.1.2]:39631 "EHLO
	south-station-annex.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890AbZBEPHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:07:39 -0500
Message-ID: <20090205100707.x5ne771u9skko00s@webmail.mit.edu>
Date: Thu, 05 Feb 2009 10:07:07 -0500
From: Adam M Belay <abelay@MIT.EDU>
To: Philippe De Muyter <phdm@macqel.be>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       lenb@kernel.org
Subject: Re: [BUG] pnpbios breaks floppy support
References: <20090131212915.GA19276@frolo.macqel>
	<49861E88.8060809@gmail.com>
	<20090202014331.xt99kri8xd0k00k4@webmail.mit.edu>
	<200902031729.02286.bjorn.helgaas@hp.com>
	<20090205121745.GA16397@frolo.macqel>
In-Reply-To: <20090205121745.GA16397@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.0.3)
X-Spam-Score: -2.599
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe, thanks for reporting this bug and testing the fix.  Bjorn,
this patch looks good to me.

Thanks,
Adam

Quoting Philippe De Muyter <phdm@macqel.be>:

> On Tue, Feb 03, 2009 at 05:29:01PM -0700, Bjorn Helgaas wrote:
>
>> I think we should just change floppy.c to request only ports
>> 2, 4-5, and 7, with something like the patch below.  Philippe,
>> can you give it a try?
>
> Your patch solves the problem : no error from the floppy initialisation,
> and the floppy works effectively.
>
> Thank you
>
> Philippe
>


