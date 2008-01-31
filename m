Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbYAaO4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbYAaO4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYAaO4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:56:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbYAaO4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:56:36 -0500
Date: Thu, 31 Jan 2008 15:56:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Force enable HPET on (some?) ICH9 boards
Message-ID: <20080131145620.GC27855@elte.hu>
References: <1201444379-4223-1-git-send-email-alistair@devzero.co.uk> <924EFEDD5F540B4284297C4DC59F3DEE6CD87A@orsmsx423.amr.corp.intel.com> <200801300836.27647.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801300836.27647.alistair@devzero.co.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alistair John Strachan <alistair@devzero.co.uk> wrote:

> Are you going to pick this patch up via the x86 tree, or shall I 
> forward it to Andrew or trivial@?
> 
> Do you want me to re-send with Venki's ack?

no need, we merged your improvement via x86.git and it is now in Linus's 
latest tree:

  commit dff244af014144e4ac87dfc5b6e450dc8832710e
  Author: Alistair John Strachan <alistair@devzero.co.uk>
  Date:   Wed Jan 30 13:33:39 2008 +0100

      x86: force enable HPET on (some?) ICH9 boards

it should first show up in v2.6.25-rc1. Thanks,

	Ingo
