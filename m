Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXB0Nzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXB0Nzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXB0Nzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:55:50 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:21454 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbXB0Nzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rx6Era0NOCWd3tmWgZK1u5hr9DolHqrar9Ira/Je6ycXbRZWmozTG2jn+9PdQD1z19ewH4tx6KhwIq8DEm9dhO4GZV6IMWINWdWsMbh57+AOviaNknKWst9fTETrGC93Q2W8HGFF09xP2AP2ryY3xcnR7HZDbrXRAZa1lCYXxXs=
Message-ID: <961aa3350702270555jecce07bge5e6a5f460ca7d12@mail.gmail.com>
Date: Tue, 27 Feb 2007 22:55:42 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>
Subject: Re: __must_check and driver model
In-Reply-To: <20070227120450.GB2154@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070227120450.GB2154@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/27, Russell King <rmk+lkml@arm.linux.org.uk>:
> I'm still seeing lots of warnings about unchecked return codes from
> driver model functions.
>
> These must have been around for at least three months, if not longer,
> and there seems to be very little progress towards resolving them.
> Maybe if no one cares about fixing the warnings, we shouldn't have
> the warnings at all since they're just mere noise.

I have patch series to shut up __must_check warning about
sysfs_create_link() in drivers/base/core.c (I made before, but
I forgot to send)
