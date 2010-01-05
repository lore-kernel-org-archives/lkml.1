Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232Ab0AERcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0AERcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0AERcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:32:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49568 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0AERcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:32:32 -0500
Date: Tue, 5 Jan 2010 17:31:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rabin Vincent <rabin@rab.in>, mmarek@suse.cz, linux-kernel@vger.kernel.org,
       Simon Horman <horms@verge.net.au>, wangcong@zeuux.org,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] scripts: add ARM support to decodecode
Message-ID: <20100105173120.GA10941@n2100.arm.linux.org.uk>
References: <1262184839-24497-1-git-send-email-rabin@rab.in> <20091231051858.GA31256@verge.net.au> <20100105145758.GA2690@debian> <20100105070658.766317d2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105070658.766317d2@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 07:06:58AM -0800, Arjan van de Ven wrote:
> I'm fine with this, but I wonder if ARM could switch to the <>
> convention for the faulting instruction, just to keep things
> consistent..

I did mention exactly that on the previous review round on this patch;
the problem is that it won't change older kernels, and if anyone is
still using ksymoops or similar parsing stuff, it could break on
such a change.
