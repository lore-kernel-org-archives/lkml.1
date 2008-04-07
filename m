Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYDGTCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYDGTCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDGTCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:02:22 -0400
Received: from gw.goop.org ([64.81.55.164]:58057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbYDGTCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:02:21 -0400
Message-ID: <47FA6F82.8080305@goop.org>
Date: Mon, 07 Apr 2008 12:01:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24 of 24] xen: add balloon driver
References: <patchbomb.1207158829@localhost> <b3a316a63b9eb9f3eb4c.1207158853@localhost> <20080407085134.GD24204%yamahata@valinux.co.jp>
In-Reply-To: <20080407085134.GD24204%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> The following modification to include/xen/interface/memory.h 
> removes handles related definitions.
> It breaks ia64/xen compilation because ia64/xen uses memory interface
> not only for balloon, but also for xen_alloc_vm_area/xen_free_vm_area().
>
> Can it be added again?
>   

Yes, sure.  We're going to hit that a bit because we needed to remove 
them to make the initial upstreaming smooth.

    J
