Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZKRTbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZKRTbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbZKRTbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:31:46 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45532 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbZKRTbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:31:45 -0500
MIME-Version: 1.0
In-Reply-To: <20091117185742.GA19829@srcf.ucam.org>
References: <1258468659-5446-1-git-send-email-mjg@redhat.com> 
	<ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> 
	<1258474180.16176.62.camel@localhost.localdomain> <20091117185742.GA19829@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 18 Nov 2009 20:30:07 +0100
Message-ID: <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 19:57, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Ok. How about something like this? It adds an extra field to the stat
> file and introduces David's suggestion of making it pollable.

Hmm, while thinking more about it, I'm still not sure if we should add
an interface which can work for a single user only, and add a timer to
the kernel which is only used by a userspace policy thing.

Wouldn't it be good enough, if we add a file "idle_since" which
contains the time of the actual disk idle time, and userspace can
schedule a re-examination of that value at the actual end of the idle
time it is looking for?

Thanks,
Kay
