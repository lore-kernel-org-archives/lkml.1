Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYG2VAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYG2VAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYG2VAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:00:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36210
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752743AbYG2VAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:00:43 -0400
Date: Tue, 29 Jul 2008 14:00:40 -0700 (PDT)
Message-Id: <20080729.140040.72089155.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: tony.luck@intel.com, jgarzik@redhat.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, netdev@vger.kernel.org, matthew@wil.cx,
       holt@sgi.com, linux-net-drivers@solarflare.com
Subject: Re: [Patch] fix ia64 build failure when CONFIG_SFC=m
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080729174839.GG10471@solarflare.com>
References: <20080729013650.GH9663@sgi.com>
	<57C9024A16AD2D4C97DC78E552063EA3080BA318@orsmsx505.amr.corp.intel.com>
	<20080729174839.GG10471@solarflare.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 29 Jul 2008 18:48:41 +0100

> I think a single core in each package can generally saturate the
> memory bus and this is why spreading the load wider is not useful.

I disagree, especially for routing and firewall setups.

You want as many cpu threads as possible, even on the same core,
doing the routing and firewall lookups through the various
datastructures, in parallel.
