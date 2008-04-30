Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYD3BdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYD3BdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYD3BdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:33:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYD3BdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:33:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: benh@kernel.crashing.org
X-Fcc: ~/Mail/linus
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: PTRACE_{READ,WRITE}{TEXT,DATA}
In-Reply-To: Benjamin Herrenschmidt's message of  Wednesday, 30 April 2008 10:06:30 +1000 <1209513990.18023.199.camel@pasglop>
References: <1209441248.18023.124.camel@pasglop>
	<20080429220733.B3FCC26FA24@magilla.localdomain>
	<1209513990.18023.199.camel@pasglop>
X-Windows: garbage at your fingertips.
Message-Id: <20080430013232.81E2E26FA24@magilla.localdomain>
Date: Tue, 29 Apr 2008 18:32:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yup, I didn't know gdb used /proc/pid/mem to be honest ... as long as it
> goes through access_process_vm(), I'm fine anyway.

All user ABIs for this have always boiled down to access_process_vm.
