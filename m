Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZJPTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZJPTA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZJPTA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:00:58 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:62813 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZJPTA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:00:58 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMtf2EqrR7Hu/2dsb2JhbADBFpgghDAE
X-IronPort-AV: E=Sophos;i="4.44,574,1249257600"; 
   d="scan'208";a="215361115"
From: Roland Dreier <rdreier@cisco.com>
To: Andrey Rahmatullin <wrar@altlinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/staging/rt2860 doesn't compile
References: <20091014063824.GD6298@wrars-comp.wrarsdomain>
	<20091014182729.GC19095@wrars-comp.wrarsdomain>
	<20091016085738.GG19095@wrars-comp.wrarsdomain>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 16 Oct 2009 12:00:58 -0700
In-Reply-To: <20091016085738.GG19095@wrars-comp.wrarsdomain> (Andrey
	Rahmatullin's message of "Fri, 16 Oct 2009 14:57:39 +0600")
Message-ID: <ada1vl3xixh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Oct 2009 19:00:58.0676 (UTC) FILETIME=[FF2C3740:01CA4E92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > For the archives: it just means that CONFIG_WIRELESS_EXT should be enabled.

Which means the driver should probably do "select WIRELESS_EXT" in
Kconfig.  Would be an easy patch to send if you can test it....
