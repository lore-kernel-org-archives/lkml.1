Return-Path: <linux-kernel-owner+w=401wt.eu-S965448AbYECAKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965448AbYECAKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764992AbYECAK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:10:28 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:16225 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbYECAK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:10:27 -0400
X-IronPort-AV: E=Sophos;i="4.27,429,1204531200"; 
   d="scan'208";a="25065008"
From: Roland Dreier <rdreier@cisco.com>
To: "Moore\, Eric" <Eric.Moore@lsi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B4C@NAMAIL2.ad.lsil.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 17:10:25 -0700
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B4C@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 17:20:58 -0600")
Message-ID: <adak5ic2qoe.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 May 2008 00:10:25.0315 (UTC) FILETIME=[15FD7F30:01C8ACB2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Under platforms where writeq is not defined, what should I do?

Umm... is it too late to change your chip design?

Seriously, for example on PowerPC 440SPe (which has a PCIe bus on a
32-bit PowerPC core), I don't know any way you can generate a 64-bit PCI
transaction.  Even on 32-bit x86 I think you're stuck using something
ugly like MMX to do it.

Basically it's going to be architecture-dependent at best.

 - R.
