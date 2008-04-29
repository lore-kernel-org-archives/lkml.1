Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYD2WHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYD2WHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYD2WHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:07:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYD2WHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:07:46 -0400
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
In-Reply-To: Benjamin Herrenschmidt's message of  Tuesday, 29 April 2008 13:54:08 +1000 <1209441248.18023.124.camel@pasglop>
References: <1209441248.18023.124.camel@pasglop>
X-Zippy-Says: If elected, Zippy pledges to each and every American a 55-year-old
    houseboy...
Message-Id: <20080429220733.B3FCC26FA24@magilla.localdomain>
Date: Tue, 29 Apr 2008 15:07:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any sense in adding that.  Using /proc/pid/mem is already the
"efficient" API for this known to userland.  I don't think keeping the fd
around for that is any great burden, and if you do then the one pread64
call is just as efficient as one ptrace call to do the same thing.


Thanks,
Roland
