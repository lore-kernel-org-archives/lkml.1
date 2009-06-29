Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbZF2Acb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbZF2Acb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZF2AcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:32:24 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55598 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZF2AcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:32:23 -0400
Date: Sun, 28 Jun 2009 20:32:12 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, earl_chew@agilent.com
Subject: Re: [PATCH 0/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090629003212.GA2479@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622172818.GB14673@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, Version 3 of this patchset.  This is the same set of patches as before only
redifffed and modified in the following ways:

1) Rediffed to the head of linus' tree

2) Rediffed to apply on top of Oleg's 2 patches that clean up do_coredump

3) Modified to use pipe_wait to wait for pipe readers to hit zero rather than
the racy/buggy process of waiting on the reader process to exit.


Neil

