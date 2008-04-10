Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbYDJPgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYDJPgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbYDJPf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:35:58 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:5533 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbYDJPf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:35:57 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Jack Harvard <jack.harvard@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: gettimeofday() resolution in Linux?
From: Andi Kleen <andi@firstfloor.org>
References: <a72f6a3c0804100740s687beacbh80653107f4a7b702@mail.gmail.com>
	<20080410150424.GD2160@csclub.uwaterloo.ca>
Date: Thu, 10 Apr 2008 17:35:25 +0200
In-Reply-To: <20080410150424.GD2160@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Thu, 10 Apr 2008 11:04:24 -0400")
Message-ID: <87fxttn2o2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Apr 2008 15:28:41.0862 (UTC) FILETIME=[8E972260:01C89B1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsorense@csclub.uwaterloo.ca (Lennart Sorensen) writes:
>
> On many systems gettimeofday uses the TSC, but on many multicore systems
> the TSC on each core may be out of sync, in which case the cpu you are
> running on may give a different gettimeofday result than another cpu,
> which is probably a bad thing for some processes.

In this case Linux falls back to other timers which are slower and 
less accurate.

jiffies based gettimeofday is theoretically possible, but near
never used.

-Andi
