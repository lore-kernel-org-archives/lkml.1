Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbZG3Pxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbZG3Pxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 11:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZG3Pxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 11:53:41 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34941 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbZG3Pxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 11:53:41 -0400
To: Paul Rolland <rol@as2917.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc4 - slab entry tak_delay_info leaking ???
References: <20090729082047.048ee1a8@tux.DEF.witbe.net>
	<20090730120715.65bf01ff@tux.DEF.witbe.net>
	<20090730122605.465d4f8b@tux.DEF.witbe.net>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 30 Jul 2009 16:53:33 +0100
In-Reply-To: <20090730122605.465d4f8b@tux.DEF.witbe.net> (Paul Rolland's message of "Thu\, 30 Jul 2009 12\:26\:05 +0200")
Message-ID: <tnxeiry88w2.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2009 15:53:39.0065 (UTC) FILETIME=[E79F2E90:01CA112D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland <rol@as2917.net> wrote:
>> On Wed, 29 Jul 2009 08:20:47 +0200
>> Paul Rolland <rol@as2917.net> wrote:
>> > Since I'm running 2.6.31-rc? (3 or 4 I think), I often find my machine
>> > with my X session killed in the morning, and the kdm login screen
>> > displayed.
[...]
> Well, I've killed my X session, and it stopped the "leak"... but
> didn't recover the "lost" task_delay_info...

You could try to enable CONFIG_KMEMLEAK and see if you get any leaks
reported for the "lost" task_delay_info (see Documentation/kmemleak.txt).

-- 
Catalin
