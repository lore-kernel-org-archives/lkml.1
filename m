Return-Path: <linux-kernel-owner+w=401wt.eu-S965062AbXBZMfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062AbXBZMfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 07:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXBZMfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 07:35:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965062AbXBZMfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 07:35:41 -0500
To: kalium@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: latencies due to disk writes
References: <20070226015439.97500@gmx.net>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 26 Feb 2007 07:35:35 -0500
In-Reply-To: <20070226015439.97500@gmx.net>
Message-ID: <y0m649phzag.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


kalium@gmx.de writes:

> I'm experiencing extreme lags during disk writes. [...]

Wacky idea: "ionice -n 7 -c 2" down the pdflush/swapd kernel threads.

- FChE
