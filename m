Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbYBAJl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbYBAJl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBAJlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:41:17 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:54736 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYBAJlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fpmhqwlA9z1ibtR6SHEL6cFtdK3UD5gvwRND09LMwTdppNGWIJ2yKm73ZTAGcAR7gs6vYRdBwslg0KOrwvWF4j63gHx2V2AlWOZqNvMYf27/vhj1HItNPL5TmI8SbRAJr4Chb3KOBor0Mh7TpinzcT1UzrT/q0gNLKZ0YXIxJ/k=
Message-ID: <386072610802010141g340cdb14gcd244ab87ffc855e@mail.gmail.com>
Date: Fri, 1 Feb 2008 17:41:14 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [spi-devel-general] [PATCH 0/6] [Blackfin] SPI driver updates
Cc: spi-devel-general@lists.sourceforge.net, "Bryan Wu" <bryan.wu@analog.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801311250.46415.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201684421-26124-1-git-send-email-bryan.wu@analog.com>
	 <200801311250.46415.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 4:50 AM, David Brownell <david-b@pacbell.net> wrote:
> I've forwarded these to Andrew, with my signoff and updated comments.
> You still need to work on having your patch descriptions match up
> to what the patches actually do...
>

Thanks a lot, I will try to make it more clearer next time.

> Patches 3-5 in this series seem to have a common thread:  waiting
> until BIT_STAT_SPIF is set before moving to the next step of the
> transfer.  Next time something similar happens, I'd rather see just
> one patch addressing the issue on all code paths ... not three small
> patches that only fix it for a few of the code paths.
>

OK, I will try to merge these same bug fixing into one patch.

> Also, two of those three patches describe their updates as fixing
> a "regression", or "reverting" the code.  Was this a bug that came
> in those patches you wanted to merge to 2.6.24?  If so, shouldn't
> those regression fixes go into the stable series?
>

Yes, I agree with you. Actually, I intend to send out these bug fixing
patch ASAP, but we want to make sure our tester verify this bug was
fixing first.

Thanks
-Bryan
