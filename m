Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYEEULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYEEULU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYEEULE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:11:04 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:18718 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbYEEULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:11:03 -0400
To: "Kevin Burton" <burton@tailrank.com>
Cc: "FD Cami" <francois.cami@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
From: Andi Kleen <andi@firstfloor.org>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	<20080505131607.5556b1f2@olorin>
	<30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	<20080505212831.22371732@olorin>
	<30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
Date: Mon, 05 May 2008 22:10:40 +0200
In-Reply-To: <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com> (Kevin Burton's message of "Mon, 5 May 2008 12:42:31 -0700")
Message-ID: <878wyocy0v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 May 2008 20:03:43.0845 (UTC) FILETIME=[1EDDA950:01C8AEEB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Kevin Burton" <burton@tailrank.com> writes:
>
> What I want to do is either disable the page cache entirely or just
> tell the OS to cache at max 10% of the available memory.

FYI page cache includes the memory your program uses. No page 
cache would mean no user space, 10% would mean user space uses only
10%. One way that would fulfil your request literally is to boot with 
mem=<10% of your ram>, but I guess you don't really want that.

If you don't want your application to be swapped at all you
should probably investigate mlock(2)/mlockall(2)

-Andi
