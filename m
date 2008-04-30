Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbYD3VST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbYD3VST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761762AbYD3VR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:17:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48007 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbYD3VRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:17:55 -0400
In-Reply-To: <20080430203839.GA19203@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netdev-owner@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [patch] net: ipv6 build fix
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF82C2A611.73628201-ON8825743B.00745835-8825743B.0074F726@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 30 Apr 2008 14:17:41 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 04/30/2008 15:17:42,
	Serialize complete at 04/30/2008 15:17:42
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,
        That fix is not correct. Pavel Emelyanov posted a
correct fix to netdev earlier today. Apparently, the context
matched ipv6_getsockopt() in the split version, but those
changes belong in compat_ipv6_getsockopt(), as in Pavel's
fix.
        Since the original patch was correct, I'm not sure
if the fix will have the same problem or not.

                                        +-DLS

