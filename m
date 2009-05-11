Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZEKRz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZEKRz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZEKRzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:55:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34327 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751318AbZEKRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:55:45 -0400
Date: Mon, 11 May 2009 18:55:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511185513.45ea4754@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905111032u13051b74g81573a18e3545a81@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
	<ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk>
	<ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
	<20090511094151.6014cafb@infradead.org>
	<ac3eb2510905111032u13051b74g81573a18e3545a81@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The same applies when you leave initiramfs, the in-initramfs udevd
> copy is killed, and the one from the real root is started. You may
> miss events in-between, and need to run a full coldplug again, not
> only to apply the policy, but also to make sure that all nodes are
> there. The policy can run in the background for most things just fine,
> the missing node may cause trouble.

What a strange behaviour. Why not run a single udev instance inside the
tmpfs you are turning into dev and will then attach to the real rootfs
when it appears ? You only need to build /dev once.

> Yeah, and I mentioned many other ways this is useful, to do stuff in
> parallel, to be able to rescue, and to have custom systems which do

But there are lots where it is not - and those you've mentioned where it
might be seem rather stretched at best.
