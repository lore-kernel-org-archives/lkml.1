Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYD3AHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYD3AHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYD3AGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:06:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:36157 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYD3AGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:06:47 -0400
Subject: Re: PTRACE_{READ,WRITE}{TEXT,DATA}
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland McGrath <roland@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20080429220733.B3FCC26FA24@magilla.localdomain>
References: <1209441248.18023.124.camel@pasglop>
	 <20080429220733.B3FCC26FA24@magilla.localdomain>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 10:06:30 +1000
Message-Id: <1209513990.18023.199.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 15:07 -0700, Roland McGrath wrote:
> I don't see any sense in adding that.  Using /proc/pid/mem is already the
> "efficient" API for this known to userland.  I don't think keeping the fd
> around for that is any great burden, and if you do then the one pread64
> call is just as efficient as one ptrace call to do the same thing.

Yup, I didn't know gdb used /proc/pid/mem to be honest ... as long as it
goes through access_process_vm(), I'm fine anyway.

Cheers,
Ben.

