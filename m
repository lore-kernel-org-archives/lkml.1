Return-Path: <linux-kernel-owner+w=401wt.eu-S933909AbYETVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909AbYETVQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760714AbYETVQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:16:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41729
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759997AbYETVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:16:11 -0400
Date: Tue, 20 May 2008 14:16:07 -0700 (PDT)
Message-Id: <20080520.141607.147404741.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Remove all users of cpu_to_{le|be}{16|32|64}p
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211311449.5915.193.camel@brick>
References: <1211311449.5915.193.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 20 May 2008 12:24:08 -0700

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> akpm: applies on top of the 21-patch aligned get/put helpers series.

Can you provide some contextual information in the changelog
message?

Why are the cpu_to_*p() uses going away?  Do the normal cpu_to_*() now
transparently emit the special other-endian loads and stores some
cpus?

You should always describe such things in your changelog message so
people don't need to ask these kinds of questions.
