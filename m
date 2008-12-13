Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbYLMQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbYLMQ7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbYLMQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:59:13 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:24709 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYLMQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:59:12 -0500
X-IronPort-AV: E=Sophos;i="4.36,216,1228089600"; 
   d="scan'208";a="117838683"
From: Roland Dreier <rdreier@cisco.com>
To: "Giangiacomo Mariotti" <giangiacomo.mariotti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Misuse of sizeof
References: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 13 Dec 2008 08:59:10 -0800
In-Reply-To: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
	(Giangiacomo Mariotti's message of "Sat, 13 Dec 2008 17:31:06 +0100")
Message-ID: <adak5a41069.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Dec 2008 16:59:10.0895 (UTC) FILETIME=[1E9413F0:01C95D44]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > IMO there's a bug in the use of sizeof in /arch/x86/boot/main.c, it's
 > also a strange style.

Style is of course a matter of opinion, but sizeof is an operator, not a
function, and as far as I can see, there's no bug in how it is used even
without your patch.

 - R.
