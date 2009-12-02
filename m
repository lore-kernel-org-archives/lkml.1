Return-Path: <linux-kernel-owner+w=401wt.eu-S1751340AbZLBFa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbZLBFa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZLBFa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:30:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46757 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbZLBFa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:30:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: davidjon@xenontk.org
Subject: Re: OOM kernel behaviour
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jonathan Miles <jon@cybus.co.uk>,
       penberg@cs.helsinki.fi
In-Reply-To: <4B15FA04.2020206@xenontk.org>
References: <20091202132026.5C55.A69D9226@jp.fujitsu.com> <4B15FA04.2020206@xenontk.org>
Message-Id: <20091202142900.5C64.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 14:31:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/02/2009 09:59 AM, KOSAKI Motohiro wrote:
> > Proprietary module is loaded.
> 
> That's the Broadcom wireless wl driver. It isn't causing the problem.
> 
> > 
> > Probably, some program in your system leaked memory.
> > 
> 
> Is there some way to find out? I tried to analyse top and ps output
> but there isn't anything that stands out.

just idea.
/proc/{pid}/smaps show what file is swapped out. usually, leaked page
is swapped because nobody touched it.



