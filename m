Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbXBFM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbXBFM0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXBFM0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:26:31 -0500
Received: from colin.muc.de ([193.149.48.1]:2374 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbXBFM0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:26:30 -0500
Date: 6 Feb 2007 13:26:28 +0100
Date: Tue, 6 Feb 2007 13:26:28 +0100
From: Andi Kleen <ak@muc.de>
To: Zachary Amsden <zach@vmware.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 8/11] Add a CPU KHZ calibration function to paravirt-ops
Message-ID: <20070206122628.GB47229@muc.de>
References: <200702060353.l163rNP7000763@zach-dev.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702060353.l163rNP7000763@zach-dev.vmware.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 07:53:23PM -0800, Zachary Amsden wrote:
> Provide a paravirtualized way to get the CPU clock frequency; this allows much
> of the code in tsc.c to be shared between all paravirt implementations.

Is this really needed? 

What worries me somewhat of your patches is that you seem
to be quick at adding new hooks. But I would like to keep
paravirtops as minimal as possible with new hooks only
added when there is a very good justification.

I don't see it here.

-Andi
