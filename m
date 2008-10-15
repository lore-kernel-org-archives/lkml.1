Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYJOWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYJOWlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYJOWl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:41:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53979
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752549AbYJOWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:41:28 -0400
Date: Wed, 15 Oct 2008 15:41:05 -0700 (PDT)
Message-Id: <20081015.154105.67228830.davem@davemloft.net>
To: linux@dominikbrodowski.net
Cc: sven.wegener@stealer.net, adobriyan@gmail.com, davej@redhat.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: sparc64 allmodconfig build failure...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081015221104.GA18320@isilmar.linta.de>
References: <20081014.154916.232117559.davem@davemloft.net>
	<alpine.LNX.2.00.0810152354350.28346@titan.stealer.net>
	<20081015221104.GA18320@isilmar.linta.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Thu, 16 Oct 2008 00:11:04 +0200

> [PATCH] cpufreq: remove policy->governor setting in drivers initialization
> 
> As policy->governor is already set to CPUFREQ_DEFAULT_GOVERNOR in the
> (always built-in) cpufreq core, we do not need to set it in the drivers.
> This fixes the sparc64 allmodconfig build failure.
> 
> Also, remove a totally useles setting of ->policy in cpufreq-pxa3xx.c.
> 
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

This works for me:

Acked-by: David S. Miller <davem@davemloft.net>
