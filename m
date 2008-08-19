Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYHSToL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYHSToL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYHSTnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:43:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYHSTny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:43:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
X-Fcc: ~/Mail/linus
Cc: oleg@tv-sign.ru, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: tracehook breaks dhcpcd child processing
In-Reply-To: Andi Kleen's message of  Tuesday, 19 August 2008 17:57:22 +0200 <20080819155722.GA25695@basil.nowhere.org>
References: <20080819155722.GA25695@basil.nowhere.org>
X-Zippy-Says: I just bought FLATBUSH from MICKEY MANTLE!
Message-Id: <20080819194318.8572815426B@magilla.localdomain>
Date: Tue, 19 Aug 2008 12:43:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report.

Was this problem after the fixes in:
commit 5861bbfcc10fc0358abf52c7d22850c8d180f0b0
commit 5c7edcd7ee6b77b88252fe4096dce1a46a60c829
?

Do you know the process-level details that cause the problem?
(i.e. exits with what parent/signals/etc conditions)
It may take me a bit to set up an opensuse 11.0 vm to try its dhcpcd.


Thanks,
Roland
