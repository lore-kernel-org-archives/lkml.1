Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXGQQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXGQQWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXGQQWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:22:09 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:26504 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbXGQQWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:22:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Se0YHFVo35tK1tnCzITJ3V/LVB7d8HvHgppN1e972C1rt54OHaeeQOd4DEI2sGLpH6lSNTXdkAWZekB5i6GUdtB8MX7ngoWkqWyxYqyMRRfB/8sZoysMsUfF92N14hbv4aXtDkgkYKJKnQFm4UduBWy1FgM2MRnV9TAPMkl/+4Y=
Message-ID: <961aa3350707170922o6d3afb03lf9670f096379e47a@mail.gmail.com>
Date: Wed, 18 Jul 2007 01:22:05 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 3/10] sysfs: fix error handling in create_files()
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070716162952.GB30975@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716134855.GA1858@APFDCB5C> <20070716135230.GC2040@APFDCB5C>
	 <20070716172945.54e07c3c@gondolin.boeblingen.de.ibm.com>
	 <20070716162952.GB30975@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/17, Greg KH <gregkh@suse.de>:
> On Mon, Jul 16, 2007 at 05:29:45PM +0200, Cornelia Huck wrote:
> > On Mon, 16 Jul 2007 22:52:30 +0900,
> > Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >
> > > Current error handling in create_files() attempts to remove
> > > all attributes passed by argument by remove_files(). But it should
> > > only remove the attributes that have been successfully added.
> >
> > While this is certainly cleaner, a question out of curiousity: Does
> > this fix any problem you saw? sysfs_hash_and_remove() used to be safe
> > on non-existing attributes...
>
> I agree, the existing code should work just fine, are you finding that
> it does not for some reason?

As you and Cornelia said, this patch doesn't fix anything.
I made a wrong guess for some oops call trace.
