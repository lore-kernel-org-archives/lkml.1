Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYGWWb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYGWWb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYGWWbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:31:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55771
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbYGWWbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:31:44 -0400
Date: Wed, 23 Jul 2008 15:31:43 -0700 (PDT)
Message-Id: <20080723.153143.10048360.davem@davemloft.net>
To: mingo@elte.hu
Cc: johnpol@2ka.mipt.ru, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, vegard.nossum@gmail.com, rjw@sisk.pl,
       cl@linux-foundation.org, auke-jan.h.kok@intel.com,
       jeffrey.t.kirsher@intel.com
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
 overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080722133415.GA23046@elte.hu>
References: <20080721.163349.113841731.davem@davemloft.net>
	<20080722075000.GB15807@elte.hu>
	<20080722133415.GA23046@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 22 Jul 2008 15:34:15 +0200

> it's now past 50 successful iterations with e1000e+netconsole enabled 
> again with the fix applied, and not a single crash, hang, memory 
> corruption or other weirdness happened. Jeff, please apply the fix 
> below.

I'll take care of integrating this, thanks Ingo.
