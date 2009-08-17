Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZHQVbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZHQVbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZHQVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:31:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbZHQVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:31:40 -0400
Date: Mon, 17 Aug 2009 17:31:37 -0400
From: Dave Jones <davej@redhat.com>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: md deadlock (2.6.31-rc5-git2)
Message-ID: <20090817213137.GA32521@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mike Snitzer <snitzer@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20090817201750.GA21562@redhat.com> <170fa0d20908171416o1e6da4d0xab02cd765a924306@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170fa0d20908171416o1e6da4d0xab02cd765a924306@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 05:16:25PM -0400, Mike Snitzer wrote:
 > On Mon, Aug 17, 2009 at 4:17 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > This kernel is a bit old (it's what we froze on for Fedora 12 alpha,
 > > and we haven't started building install images with anything newer yet),
 > > but I don't recall seeing anything similar posted recently..
 > >
 > > While creating a series of md arrays, I got the mdadm process to just lock up.
 > > Looking in dmesg showed that it had warned about it too ..
 > ...
 > > 2 locks held by mdadm/2249:
 > >  #0:  (&new->reconfig_mutex#2){+.+.+.}, at: [<ffffffff813edcab>] mddev_lock+0x2a/0x40
 > >  #1:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
 > 
 > This was fixed with commit: c8c00a6915a2e3d10416e8bdd3138429beb96210

excellent! I missed that. thanks.

	Dave
