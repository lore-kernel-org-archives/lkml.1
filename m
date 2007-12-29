Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbXL2FGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbXL2FGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 00:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbXL2FGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 00:06:05 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:44856 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750735AbXL2FGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 00:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CB8q29sY7ZhJY600Io0maXFqT3S37BSQKMChq6JQeBMrCNEdv+85UXD+hxwvUyllPH+lAZa0AaFOOnbRiMjp/TqsQmvQOYAcXAXflcYpqhwnnpeVm8dUCtE2MdjqWl2BqEhHvpbSdoLg/8ZO+U5OWQkq0Rfud6ZzC0z0UJZWwFQ=
Message-ID: <a8e1da0712282106j666988acndcc5eab302a5a284@mail.gmail.com>
Date: Sat, 29 Dec 2007 13:06:03 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071229044200.GA16712@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
	 <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
	 <1198892544.6821.103.camel@twins>
	 <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com>
	 <1198893445.6821.108.camel@twins>
	 <a8e1da0712281803i11c04b37ic5e92a4c27c79b07@mail.gmail.com>
	 <a8e1da0712281836t418881fbi5c8b924ba353bf90@mail.gmail.com>
	 <20071229044200.GA16712@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 12:42 PM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> > >
> > The full boot dmesg with lockdep output is out, there's one warnings in it :
>
> Please fix that warning before the next repost of these patches (along
> with fixing the problem of them not being able to be applied and
> successfully built at every point in the series...)
>

Ok, thanks, I will fix them and repost.
