Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZDNQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZDNQ1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZDNQ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:27:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4122 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZDNQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:27:11 -0400
Subject: Re: [PATCH 00/14] convert voyager over to the x86 quirks model
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 09:27:04 -0700
Message-Id: <1239726424.32203.133.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 10:51 -0500, James Bottomley wrote:
> This patch series applies on git head (obviously with
> 965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 reverted)

If accepted, you probably want to revert:

commit 8ed01bbb89c943f714bdf4876f749b1b01792f65
Author: Joe Perches <joe@perches.com>
Date:   Tue Apr 7 21:13:49 2009 -0700

    MAINTAINERS - Remove x86/Voyager no longer in tree

as well.


