Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbXHABan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbXHABan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXHABad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:30:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXHABad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:30:33 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Simple Performance Counters: Core Piece
References: <11859243123373-git-send-email-clameter@sgi.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 31 Jul 2007 21:30:27 -0400
In-Reply-To: <11859243123373-git-send-email-clameter@sgi.com>
Message-ID: <y0m7iog6nyk.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Lameter <clameter@sgi.com> writes:

> Simple performance counters are a way to measure the performance on
> code paths in the Linux kernel. Code must be instrumented with calls
> that signal the start and the stop of a measurement.  [...]

For what it's worth, this kind of measurement widget could be usefully
recast as a pure client of the lttng/systemtap markers that Mathieu is
still working on.  Instead of the custom pc_start/pc_stop functions,
you would have generic markers to identify the start/end spots, and a
bit of callback code to compute/export the statistics to procfs.

- FChE
