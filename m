Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbXKFEvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbXKFEvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXKFEvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:51:16 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:46361 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbXKFEvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:51:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c330z9z2ERmRmaKR92uvLnXl+hDJhjfF8ZXIAHRBk7g6JgZsJKWpRxsKwiga2Hd3HTp5qpQwQMIHAqX0t/8VF+wajM29KvG3vtyIdjjW7EYPhOq8sY3142pir7shUHT7wKQX2D0V0dPvAiF1w5r7uVxFl7AtLtaaEBMXLjj+sDw=
Message-ID: <8bd0f97a0711052051v45856f6apfacd66ade1d47113@mail.gmail.com>
Date: Mon, 5 Nov 2007 23:51:13 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: a list of non-existent but included include/linux header files
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>   this list is short enough that i'll just post it here -- attempts to
> include header files under include/linux when those header files
> simply don't exist.  obviously, there might be false positives for one
> reason or another.

obviously the kgdb ones can be ignored

> (the only manual culling i did of the list was to
> remove inclusions of autoconf.h and utsrelease.h -- i assumed those
> weren't an issue for anyone.)

should do the opposite ... nobody should be including linux/autoconf.h

as for the Blackfin ones, the answer is the same last time you ask ...
the includes are for drivers we havent pushed to mainline yet
-mike
