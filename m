Return-Path: <linux-kernel-owner+w=401wt.eu-S933475AbYEUBYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbYEUBYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbYEUBX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:23:56 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:59138 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbYEUBXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:23:55 -0400
To: Dave Jones <davej@redhat.com>
Cc: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: aperture_64: use symbolic constants
From: Andi Kleen <andi@firstfloor.org>
References: <20080519123952.GA23118@elf.ucw.cz>
	<20080519125425.GD13546@elte.hu> <20080520142717.GA22794@elf.ucw.cz>
	<20080520150604.GD4843@redhat.com> <20080520153215.GA5368@elf.ucw.cz>
	<20080520154209.GD542@redhat.com>
Date: Wed, 21 May 2008 03:23:53 +0200
In-Reply-To: <20080520154209.GD542@redhat.com> (Dave Jones's message of "Tue, 20 May 2008 11:42:09 -0400")
Message-ID: <8763t8h2l2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 May 2008 01:16:50.0889 (UTC) FILETIME=[59035390:01C8BAE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:
>
> If you enable IOMMU, you _have_ to enable AGP.  (well, you don't have to,
> it does a 'select AGP' for you when you enable it :-)

That's actually not needed. The IOMMU code was carefully
written to not require AGP. The only requirement it has is that
if AGP is enabled it has to be built in.

-Andi
