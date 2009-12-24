Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZLXQBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZLXQBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 11:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZLXQBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 11:01:53 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50180 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZLXQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 11:01:53 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEYfM0urR7Ht/2dsb2JhbAC+a5YwhDME
X-IronPort-AV: E=Sophos;i="4.47,449,1257120000"; 
   d="scan'208";a="456114180"
From: Roland Dreier <rdreier@cisco.com>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No PCI-X / PCI-E cards ...
References: <1260979057.23135.70.camel@skunk> <1261089592.8827.5.camel@bip>
	<adahbrp43x7.fsf@roland-alpha.cisco.com>
	<1261477857.22127.23.camel@skunk> <1261573481.4822.14.camel@skunk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Dec 2009 08:01:49 -0800
In-Reply-To: <1261573481.4822.14.camel@skunk> (Xavier Bestel's message of
	"Wed, 23 Dec 2009 14:04:41 +0100")
Message-ID: <ada4ong1hua.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Dec 2009 16:01:52.0493 (UTC) FILETIME=[687391D0:01CA84B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > It looks like if the board has been flashed with the wrong bios (the
 > dmidecode info isn't consistent with what I see on the board).
 > Is there a way to workaround that in the kernel ?

Wrong BIOS is pretty fundamental -- the BIOS could have messed up many
undocumented (and possibly write-once) register settings etc.  The
kernel can work around slighly broken ACPI tables or things like that,
but if, say, undocumented write-only north bridge registers are wrong,
not much we can do about that.

Really you better just get the right BIOS on the board.

 - R.
