Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXDIHnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXDIHnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 03:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXDIHnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 03:43:04 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25728 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXDIHnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 03:43:02 -0400
Message-ID: <4619EF43.3020104@sw.ru>
Date: Mon, 09 Apr 2007 11:46:11 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 6/7] Containers (V8): BeanCounters over generic process
 containers
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.840593000@menage.corp.google.com>
In-Reply-To: <20070407001324.840593000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> This patch implements the BeanCounter resource control abstraction
> over generic process containers. It contains the beancounter core
> code, plus the numfiles resource counter. It doesn't currently contain
> any of the memory tracking code or the code for switching beancounter
> context in interrupts.
> 
> Currently all the beancounters resource counters are lumped into a
> single hierarchy; ideally it would be possible for each resource
> counter to be a separate container subsystem, allowing them to be
> connected to different hierarchies.

Thanks for your attention, but since we have decided to build a
"new" resource controllers above your containers infrastructure,
I think there is no need in further BC code porting.

Thanks,
Pavel.
