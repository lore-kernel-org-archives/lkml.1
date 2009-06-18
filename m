Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZFRBCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZFRBCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZFRBCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:02:35 -0400
Received: from main.gmane.org ([80.91.229.2]:56348 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZFRBCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:02:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jason Lynch <jason@calindora.com>
Subject: Re: [BUG?,FEATURE?] One core idles with 4 nice and 1 regular
 process
Date: Thu, 18 Jun 2009 01:02:21 +0000 (UTC)
Message-ID: <h1c3mt$vr4$1@ger.gmane.org>
References: <h18qm7$bf$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 207-118-117-152.dyn.centurytel.net
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 19:09:59 +0000, Jason Lynch wrote:
> If I can provide any additional information to help, I'll be happy to
> oblige.

I discovered a post on lkml from last October, wherein a user reports 
what sounds like the same issue on 2.6.25.9.

http://article.gmane.org/gmane.linux.kernel/748316/

In addition, Ubuntu's current 2.6.28 kernel appears to be immune from the 
problem, suggesting a possible configuration issue, or at least an option 
that can trigger/avoid the problem. However, comparing the configs is 
difficult due to the number of added, changed, and removed options 
between kernel versions. The differences that stood out in my initial 
comparisons were CONFIG_RT_GROUP_SCHED and CONFIG_CPUSETS, but I haven't 
yet had an opportunity to test either of them, and neither sounds 
especially promising.

I won't personally be able to do any more extensive kernel testing for 
perhaps a couple of weeks. However, if this is merely a configuration 
issue, it seems rather opaque to me, as I can't imagine this behavior 
being desirable in any case.

