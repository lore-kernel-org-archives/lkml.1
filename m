Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZCULla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZCULla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZCULlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:41:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZCULlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:41:21 -0400
Subject: Re: [PATCH] perfcounters: fix type/event_id layout on big-endian
 systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090321095651.GA7201@elte.hu>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com>
	 <20090321094246.GA5594@elte.hu>
	 <18884.47341.106849.379374@cargo.ozlabs.ibm.com>
	 <20090321095651.GA7201@elte.hu>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 12:41:15 +0100
Message-Id: <1237635675.4667.192.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 10:56 +0100, Ingo Molnar wrote:

> Maybe the best option is to get rid of the bitfields and use masks 

Yeah, I think that'll be sanest..

