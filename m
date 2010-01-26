Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456Ab0AZXy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0AZXy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388Ab0AZXxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:53:54 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:8722 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0AZXxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:53:51 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEACsPX0urRN+J/2dsb2JhbADCdZcnhDcE
X-IronPort-AV: E=Sophos;i="4.49,348,1262563200"; 
   d="scan'208";a="140462753"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
References: <20100125235013.GD2828@grease.ALLEYCAT>
	<adaiqapplv7.fsf@roland-alpha.cisco.com>
	<20100126035906.GA23347@ldl.fc.hp.com>
	<adaaaw1pl5d.fsf@roland-alpha.cisco.com>
	<20100126213803.GA12035@ldl.fc.hp.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 26 Jan 2010 15:52:52 -0800
In-Reply-To: <20100126213803.GA12035@ldl.fc.hp.com> (Alex Chiang's message of
	"Tue, 26 Jan 2010 14:38:03 -0700")
Message-ID: <adatyu8o23v.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jan 2010 23:52:53.0719 (UTC) FILETIME=[AD162E70:01CA9EE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I take it this concern is what prevents us from simply increasing
 > IB_UVERBS_MAX_DEVICES to 64 or something?

Yes, I think then the device numbers will overlap.

 - R.
