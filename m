Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYDUE1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYDUE1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 00:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbYDUE0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 00:26:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55713
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYDUE0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 00:26:54 -0400
Date: Sun, 20 Apr 2008 21:26:56 -0700 (PDT)
Message-Id: <20080420.212656.00878559.davem@davemloft.net>
To: wmb@firmworks.com
Cc: yhlu.kernel@gmail.com, dilinger@queued.net, hpa@zytor.com,
       ebiederm@xmission.com, mingo@elte.hu, akpm@linux-foundation.org,
       jfannin@gmail.com, linux-kernel@vger.kernel.org, jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
From: David Miller <davem@davemloft.net>
In-Reply-To: <480C1286.3040307@firmworks.com>
References: <480C0582.9010509@firmworks.com>
	<86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	<480C1286.3040307@firmworks.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitch Bradley <wmb@firmworks.com>
Date: Sun, 20 Apr 2008 18:05:26 -1000

> In SPARC land, at least on SunOS and Solaris, it was very convenient for 
> debugging to interrupt the OS with Stop-A and use OFW to inspect the 
> system state.  That was especially handy for live crash analysis.  Dumps 
> are useful as far as they go, but they often fail to capture detailed 
> I/O device state.

In most current SPARC systems, OFW is not usable and is completely
forgotten right after bootup in order to accomodate LDOMs and CPU
hotplug.

It's a better idea, anyways, to develop more pervasive and usable
in-kernel debugger facilities.  Then it doesn't matter if you have
"cool" firmware or not. :-)

