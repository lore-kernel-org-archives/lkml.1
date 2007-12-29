Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbXL2BkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbXL2BkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXL2BkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:40:04 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:44634 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752775AbXL2BkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TvSAPQQuApTzBaSiLkC4oMkQVXCUEh/U9HMkMlT6S01Kg3S5ZQp+JBCSSXBYU1oNIE59hAUOnkH11p2QCvXtI+SUs9VeU1ayyHTnKjNZp1H9fy4wQaq6aYAtHyQztN83LWR2X7SW95lxqxdFmqEqo0u5JVDFc34HPy8fkq6ivwU=
Message-ID: <a8e1da0712281740o3dda12b2kad05fbc6ddc392e3@mail.gmail.com>
Date: Sat, 29 Dec 2007 09:40:00 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
	 <1198891742.6821.98.camel@twins>
	 <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 9:36 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Dec 29, 2007 9:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >
> > I'm pretty sure you didn't boot that kernel with lockdep enabled.
> Yes, I will try rebuild with lockdep  and test.
No,  I checked the config , lockdep is indeed enabled. But I will try
to test with the lock debug options enabled in a while.
> >
> > Also, most, if not all, of your patches miss a patch description.
>
> Does the description really needed for it? IMHO, the subject is enough
> to descript the patches.
>
> Thanks for comment.
>
> Regards
> dave
>
