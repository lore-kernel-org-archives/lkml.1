Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYIAGZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYIAGZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYIAGZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:25:08 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:35727 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYIAGZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:25:06 -0400
X-IronPort-AV: E=Sophos;i="4.32,305,1217808000"; 
   d="scan'208";a="79569669"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org
Subject: Re: C language lawyers needed
References: <adaod3ef82e.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 31 Aug 2008 23:25:04 -0700
In-Reply-To: <adaod3ef82e.fsf@cisco.com> (Roland Dreier's message of "Wed, 27
	Aug 2008 14:43:05 -0700")
Message-ID: <adabpz8idrz.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2008 06:25:04.0363 (UTC) FILETIME=[7887C3B0:01C90BFB]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >     drivers/net/mlx4/mcg.c:217: warning: integer overflow in expression

In case anyone cares, this was indeed a gcc bug
(http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37261) and it is apparently
already fixed in the upstream gcc repository.

 - R.
