Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZCBXEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZCBXEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbZCBXEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:04:06 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:7465 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbZCBXEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:04:04 -0500
MIME-Version: 1.0
In-Reply-To: <20090302223916.GA31381@kroah.com>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	 <20090302130425.23cc628d.akpm@linux-foundation.org>
	 <20090302211820.GA21489@kroah.com>
	 <20090302133551.1266f725.akpm@linux-foundation.org>
	 <5aa163d00903021359x3a4693f5tbb7f1e3fec4d88b8@mail.gmail.com>
	 <20090302223916.GA31381@kroah.com>
Date: Mon, 2 Mar 2009 18:04:00 -0500
X-Google-Sender-Auth: 2d8c3ded7cad0853
Message-ID: <5aa163d00903021504l1965ecdi3423a43134de10d0@mail.gmail.com>
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
	support and add sysfs interface
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, fweisbec@gmail.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 5:39 PM, Greg KH <greg@kroah.com> wrote:
>
> I tried to create such an interface years ago, and the macro tricks
> involved ended up being horrible, and in the end, it didn't work.  But
> if you can come up with something, I'd love to see it.
>
> thanks,
>
> greg k-h
>

I could probably give it a shot, but possibly not until May... once
the current semester ends. I really need to understand the kernel type
system -- or at least the types that "should" be exposed to userspace
-- before thinking about the design too much. Maybe that's the
question that needs to be asked first: in general, what does a sysfs
interface into a driver look like? It's certainly flexible enough to
do a lot, and the existing interfaces allow it to do a lot, but is
there a simplification that covers some large percentage of cases?

Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph
