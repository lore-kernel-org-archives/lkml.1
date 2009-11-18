Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZKRQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZKRQH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbZKRQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:07:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43111 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbZKRQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:07:25 -0500
To: Matt Mackall <mpm@selenic.com>
Cc: David VomLehn <dvomlehn@cisco.com>, dedekind1@gmail.com,
       Marco Stornelli <marco.stornelli@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
References: <1258463404.27437.103.camel@localhost>
	<m1pr7hf93s.fsf@fess.ebiederm.org>
	<20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net>
	<m1iqd8ptg9.fsf@fess.ebiederm.org> <1258505777.3081.4.camel@calx>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 18 Nov 2009 08:07:21 -0800
In-Reply-To: <1258505777.3081.4.camel@calx> (Matt Mackall's message of "Tue\, 17 Nov 2009 18\:56\:17 -0600")
Message-ID: <m1vdh7byva.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:

> As much as I like kexec, it loses on memory footprint by about 100x.
> It's not appropriate for all use cases, especially things like
> consumer-grade wireless access points and phones.

In general I agree.  The cost of a second kernel and initrd can be
prohibitive in the smallest systems, and if you do a crash capture
with using a standalone app that is reinventing the wheel.

That said.  I can happily run kdump with only 16M-20M reserved.
So on many systems the cost is affordable.

Eric
