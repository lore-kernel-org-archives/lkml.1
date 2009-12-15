Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbZLOTc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbZLOTc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933579AbZLOTcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:32:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36154 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933537AbZLOTcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:32:00 -0500
Date: Tue, 15 Dec 2009 20:31:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] x86, amd: Get multi-node CPU info from NodeId MSR
 instead of PCI config space
Message-ID: <20091215193150.GE15443@elte.hu>
References: <20091215124418.GA6414@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215124418.GA6414@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:

> +	rdmsrl(0xc001100c, value);

Dont we want some nice, meaningfully named symbolic constant here, instead of 
0xc001100c?

	Ingo
