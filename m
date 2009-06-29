Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZF2RXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZF2RXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZF2RXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:23:39 -0400
Received: from [199.45.143.218] ([199.45.143.218]:33879 "EHLO zlynx.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752761AbZF2RXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:23:39 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 13:23:39 EDT
Message-ID: <4A48F30D.8000803@acm.org>
Date: Mon, 29 Jun 2009 10:59:57 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, oleg@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com> <87eit3l7y6.fsf@basil.nowhere.org>
In-Reply-To: <87eit3l7y6.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090629/1MLKCz-0006sO-Os-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> At least on x86 I can't see how it happens. mb() is only a compile
> time barrier and the compiler doesn't optimize over indirect callbacks
> like __pollwait() anyways.

Just a note about this. That used to be true, that GCC didn't optimize 
indirect calls. However, see -findirect-inlining in GCC 4.4.

I am not saying that it applies here, but it is something to remember.

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
