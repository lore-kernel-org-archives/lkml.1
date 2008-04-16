Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYDPXP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYDPXP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 19:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYDPXPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 19:15:18 -0400
Received: from ozlabs.org ([203.10.76.45]:37359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYDPXPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 19:15:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18438.34621.508450.720068@cargo.ozlabs.ibm.com>
Date: Thu, 17 Apr 2008 09:09:49 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC patch 23/27] Immediate Values - Powerpc Optimization NMI MCE support
In-Reply-To: <20080416213556.704299869@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
	<20080416213556.704299869@polymtl.ca>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> Use an atomic update for immediate values.

What is meant by an "atomic" update in this context?  AFAICS you are
using memcpy, which is not in any way guaranteed to be atomic.

Paul.
