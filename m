Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbZIRORG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbZIRORG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZIRORF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:17:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbZIRORF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:17:05 -0400
Date: Fri, 18 Sep 2009 07:16:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Volkov <pva@gentoo.org>
cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 regression: system hang after pptp connection
 established
In-Reply-To: <1253272818.3327.161.camel@tablet>
Message-ID: <alpine.LFD.2.01.0909180716080.4950@localhost.localdomain>
References: <1253217553.3271.77.camel@tablet>  <alpine.LFD.2.01.0909171327230.4950@localhost.localdomain>  <alpine.LFD.2.01.0909171359210.4950@localhost.localdomain> <1253272818.3327.161.camel@tablet>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 18 Sep 2009, Peter Volkov wrote:
>
> The patch fixes the problem here. Thank you very much.

Hey, thank _you_ for the sysrq output, that made it quite debuggable.

Committed as 202c4675c, and I cc'd stable.

		Linus
