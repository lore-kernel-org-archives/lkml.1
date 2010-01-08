Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238Ab0AHEHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab0AHEHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 23:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012Ab0AHEHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 23:07:41 -0500
Received: from mail2.shareable.org ([80.68.89.115]:60681 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0AHEHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 23:07:40 -0500
Date: Fri, 8 Jan 2010 04:07:38 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.30 and later] file corruption on ext3 filesystem.
Message-ID: <20100108040738.GF5011@shareable.org>
References: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001080254.o082sOXB018423@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
>   VMware Workstation 6.5.3 with 2CPUs / 512MB RAM.
>   ext3 filesystem ( /dev/sda1 ) mounted on / .

>   Run ./a.out and let the power fail (i.e. unplug the electric cable
>   or do equivalent) after more than 5 seconds (i.e. longer than kjournald's
>   commit interval). Probably 2 or 3 seconds after
>   "Let power fail after a few seconds.\n" was printed is the best.

It could be a kernel problem, but it could also be caused by VMware.

The combination of journalling, barriers, committing data safely to
disk and VMs is complicated and does not always provide filesystem
integrity on power failure, depending on many factors.

However, if you see corruption only with 2.6.30 and later, but not
with 2.6.29, that does suggest a kernel problem.

-- Jamie
