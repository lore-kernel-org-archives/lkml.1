Return-Path: <linux-kernel-owner+w=401wt.eu-S1030740AbXC2VAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030740AbXC2VAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030749AbXC2VAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:00:49 -0400
Received: from mx1.suse.de ([195.135.220.2]:51496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030740AbXC2VAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:00:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] kdb crash 2.6.10
Date: Thu, 29 Mar 2007 23:00:35 +0200
User-Agent: KMail/1.9.5
Cc: "Sri Dharmasanam (sdharmas)" <sdharmas@cisco.com>,
       linux-kernel@vger.kernel.org
References: <0D48315C0192E64BA0767F616E5A3B6601CF8A42@xmb-sjc-236.amer.cisco.com>
In-Reply-To: <0D48315C0192E64BA0767F616E5A3B6601CF8A42@xmb-sjc-236.amer.cisco.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703292300.35287.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 0xffffffff8019e3c0 compat_sys_ioctli  :
> NMI Watchdog detected LOCKUP on CPU0CPU 0

You probably need to add touch_nmi_watchdog()s at strategic points
in KDB. Or disable the nmi watchdog.

-Andi
