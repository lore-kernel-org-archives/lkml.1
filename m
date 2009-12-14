Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbZLNCzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbZLNCzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 21:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbZLNCzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 21:55:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbZLNCzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 21:55:15 -0500
Subject: Re: radeon 4830 corruption after resume
From: Dave Airlie <airlied@redhat.com>
To: Alex Chiang <achiang@hp.com>
Cc: rjw@sisk.pl, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091214023051.GA29591@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 12:52:03 +1000
Message-Id: <1260759123.3391.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 19:30 -0700, Alex Chiang wrote:
> Hi Dave, Rafael,
> 
> I can successfully suspend/resume my HP Envy, but upon resume,
> the screen is corrupted.
> 
> I used the gnome screenshot utility to capture this:
> 
> 	http://chizang.net/alex/tmp/radeon-4830-corruption.png
> 
> But that screenshot leads you to believe the corruption was
> 100%, when in reality, the text in my xterms was at least
> readable, but ugly.
> 
> Kernel is latest upstream pulled today. Userspace is Ubuntu Karmic.

Has it ever worked? can you suspend/resume without X running at all?

Its quite possibly a userspace problem but its hard to know, we
haven't changed the user modesetting pieces in the kernel at all in
quite a while.

Dave.

