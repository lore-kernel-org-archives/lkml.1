Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYHTCC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYHTCC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYHTCCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:02:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbYHTCCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:02:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: oleg@tv-sign.ru, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: tracehook breaks dhcpcd child processing
In-Reply-To: Andi Kleen's message of  Wednesday, 20 August 2008 04:01:33 +0200 <20080820020133.GP9807@one.firstfloor.org>
References: <20080819155722.GA25695@basil.nowhere.org>
	<20080819194318.8572815426B@magilla.localdomain>
	<20080820020133.GP9807@one.firstfloor.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080820020212.56A8515449D@magilla.localdomain>
Date: Tue, 19 Aug 2008 19:02:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reproduced it, SA_NOCLDWAIT broke.  I'll have a fix momentarily.

Thanks,
Roland
