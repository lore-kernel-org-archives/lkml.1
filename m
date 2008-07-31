Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYGaKPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYGaKPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYGaKPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:15:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYGaKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:15:21 -0400
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
	features not needed on embedded devices
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
In-Reply-To: <20080731.030205.153067850.davem@davemloft.net>
References: <1217497912.3454.95.camel@pmac.infradead.org>
	 <20080731.025547.35826309.davem@davemloft.net>
	 <1217498355.3454.103.camel@pmac.infradead.org>
	 <20080731.030205.153067850.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 11:15:16 +0100
Message-Id: <1217499316.3454.118.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 03:02 -0700, David Miller wrote:
> I explained why I didn't want to apply the IGMP one too.
>
> Andrew didn't like my objections, but that doesn't mean I
> need to defend my position further.

You said that it was part of the core BSD socket API and "Like TCP and
UDP, multicast capabilities are something applications can always depend
upon being available".

Andrew's response was that embedded devices have full control over their
userspace and that they are in a position to _know_ that they never use
multicast, so your argument is bogus. If they _know_ they don't want
multicast, it makes a lot of sense for them to turn it off.

While I agree with Andrew's observation, I'd also respectfully submit
that your argument is more fundamentally bogus than that. TCP and UDP
are _not_ universally available. They go away if you set CONFIG_INET=n.

-- 
dwmw2

