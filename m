Return-Path: <linux-kernel-owner+w=401wt.eu-S966495AbZLHVtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966495AbZLHVtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966245AbZLHVtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:49:10 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34738 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965739AbZLHVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:49:10 -0500
MIME-Version: 1.0
In-Reply-To: <20091208214246.GA21857@kroah.com>
References: <20091208214246.GA21857@kroah.com>
Date: Tue, 8 Dec 2009 16:49:14 -0500
Message-ID: <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
Subject: Re: 2.6.27.40 build error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Michael Krufky <mkrufky@kernellabs.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 4:42 PM, Greg KH <greg@kroah.com> wrote:
> It turns out that the patch below causes a build failure on the
> 2.6.27.40 kernel.
>
> Michael, should I just drop it, or should I take out the line with the
> "capture_transfer_done" in it, as that member is not in the structure in
> this kernel version.
>
> thanks,
>
> greg k-h

There were several different leaks and crash conditions addressed
since 2.6.27, and it is entirely possible that just removing the line
is not the correct course of action.

I would propose just dropping the patch for 2.6.27, as we would have
to rework it taking into consideration the other fixes which were done
since then.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
