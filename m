Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbZCFW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbZCFW45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZCFW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:56:48 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:52379 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZCFW4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PtnSoaOvcwVjBT9qcm0vWGGsfaH1KjlaCA28PEsei8LR8H6X4yvpVjdEO/QQmzUKkp
         n1vKvb+1Cnx5fulg2JMY3aSr/ZJU6ApZZ41LsgWkYzdoYPAcUc0aKfjdChUxaJsY0Jg6
         uSaf9oamxpNKr48EzCqa5zQvW9760L5aOyKks=
MIME-Version: 1.0
In-Reply-To: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
References: <20090304031238.WCEC18213.eastrmmtao106.cox.net@eastrmimpo03.cox.net>
Date: Fri, 6 Mar 2009 14:56:45 -0800
X-Google-Sender-Auth: 1ea3f86b6d049a41
Message-ID: <1f1b08da0903061456g7621f92cx8a1e251249d739ac@mail.gmail.com>
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
From: john stultz <johnstul@us.ibm.com>
To: Christopher Brannon <cmbrannon@cox.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 7:06 PM, Christopher Brannon <cmbrannon@cox.net> wrote:
> Under Plan 9 from Bell Labs, one queries or sets the system clock by
> reading or writing text strings to a special file named /dev/time.
> I implemented such a facility for Linux.  A read of /dev/time produces
> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
> jiffies since boot, and jiffies per second.

Ehh. Why would we want to export raw kernel internal values like
jiffies and HZ?

I think the CLOCK_MONOTONIC clockid would probably be a better value to export.

thanks
-john
