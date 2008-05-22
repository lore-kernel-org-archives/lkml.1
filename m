Return-Path: <linux-kernel-owner+w=401wt.eu-S936246AbYEVJgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936246AbYEVJgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933808AbYEVJgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:36:38 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:37624 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbYEVJgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:36:37 -0400
Message-ID: <48353D60.2050704@miraclelinux.com>
Date: Thu, 22 May 2008 18:31:12 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH 0/1] MAZE: Mazed processes monitor
References: <48297FD0.2090905@miraclelinux.com> <20080513084157.098ae2dc.akpm@linux-foundation.org>
In-Reply-To: <20080513084157.098ae2dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.5.22.21216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you for your comment and review.

> The immediate quesstion is, of course, "why does this need to be done
> in-kernel?".  I am unable to answer that from the provided changelog
> information, and I should be able to do that.

It needs to be done in kernel because excessive CPU cycle usage
is directly detected watching kernel internal task_struct.state.
It's hard to get that information outside the kernel.

Additionally, this patch's aim is to implement a
CGL (Carrier Grade Linux) requirement (AVL.14.0).

There are specs that can not be implemented outside the kernel.
These are;
  - Communication between the monitoring process and the kernel
  - Ability to define policy based on process events including
    process/thread creation and exit, and,
  - Ability to set the CPU cycle threshold to a resolution of
    one millisecond.

Thanks.
Hirofumi Nakagawa


