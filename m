Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbZI3QKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbZI3QKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZI3QKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:10:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51090 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751717AbZI3QKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:10:40 -0400
Date: Wed, 30 Sep 2009 11:10:44 -0500
From: Robin Holt <holt@sgi.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Fix irq affinity for hub based interrupts
Message-ID: <20090930161043.GE8903@sgi.com>
References: <20090930160259.GA7822@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930160259.GA7822@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:02:59AM -0500, Dimitri Sivanich wrote:
> This patch fixes handling of uv hub irq affinity.  IRQs with ALL or
> NODE affinity can be routed to cpus other than their originally assigned
> cpu.  Those with CPU affinity cannot be rerouted.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

Acked-by: Robin Holt <holt@sgi.com>
