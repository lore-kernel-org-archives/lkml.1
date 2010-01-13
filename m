Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519Ab0AMNOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0AMNOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519Ab0AMNOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:14:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:41579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0AMNOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:14:02 -0500
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       aris@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100113093240.GC6739@elte.hu>
References: <20100111191633.GT24885@redhat.com>
	 <20100111202729.GI4923@lenovo> <20100111203356.GU24885@redhat.com>
	 <20100113093240.GC6739@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 14:13:42 +0100
Message-ID: <1263388422.4244.214.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 10:32 +0100, Ingo Molnar wrote:
> other architectures have NMI concepts as well, such as Sparc64. 

I think both sparc64 and ppc64 fake NMIs by playing games with hw IRQ
priorities and partial masks. But yes.

One interesting 'feature' for the perf-nmi interaction is creating an
idle scheduling class for counters, because as long as there is a
counter present you can use his NMIs to drive the watchdog, but as soon
as there are non left, you need to install one.



