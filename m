Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYC1Ayv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYC1Ayv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYC1Ayi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:54:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39250
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753473AbYC1Ayh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:54:37 -0400
Date: Thu, 27 Mar 2008 17:54:37 -0700 (PDT)
Message-Id: <20080327.175437.98682881.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com,
       vladislav.yasevich@hp.com
Subject: Re: [PATCH 7/7] [SCTP]: Remove sctp_add_cmd_sf wrapper bloat
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-8-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-7-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1206621486-5408-8-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:38:06 +0200

> With a was number of callsites sctp_add_cmd_sf wrapper bloats
> kernel by some amount. Due to unlikely tracking allyesconfig,
> with the initial result were around ~7kB (thus caught my
> attention) while a non-debug config produced only ~2.3kB effect.
> 
> I (ij) proposed first a patch to uninline it but Vlad responded
> with a patch that removed the only sctp_add_cmd call which is
> wrapped by sctp_add_cmd_sf (I wasn't sure if I could do that).
> I did minor cleanup to Vlad's patch.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, thanks.
