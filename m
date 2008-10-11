Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYJKRGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYJKRGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 13:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbYJKRGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 13:06:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:5026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385AbYJKRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 13:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=Wf2mN/tL1jGoGA3rBXrHtO+/hD2IQfAnJ5GsWq4Buqd3pDtsyEaFVBn6Z/th7s+SLN
         dsEKA2o4aawfS6kyxLK5JpNsupbpHiY9OXcx+bDl0YKpPU2jCXNzAWV9HAcG1pfn9QsA
         N1UuaUo3H5bu8rFvsI2NzSIxvJW9ohNGT0TE8=
Date: Sat, 11 Oct 2008 19:06:10 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] ide: locking improvements
Message-ID: <20081011170610.GA7574@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <200810111645.27847.bzolnier@gmail.com> <20081011150532.GU19428@kernel.dk> <200810111756.37278.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810111756.37278.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 05:56:37PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 11 October 2008, Jens Axboe wrote:
> > On Sat, Oct 11 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Saturday 11 October 2008, Jens Axboe wrote:
> > > > On Sat, Oct 11 2008, Borislav Petkov wrote:

[... ]

Don't you just love it when all gets resolved peacefully and everything is fine
and dandy afterwards. I'm so happy we've straightened that one out. Just a final
quick note which by no means is targetting to resparkle the discussion: I have
another bug report, hm, well :), but still, the machine is a 8-core AMD Dell box
(with the option of upgrading to 16 cores) which _is_ using ide-cd so, there are
some people using that code, after all :). I'm sure those people will be happier
when it scales to that many cores.

http://bugzilla.kernel.org/show_bug.cgi?id=11498.

-- 
Regards/Gruss,
    Boris.
