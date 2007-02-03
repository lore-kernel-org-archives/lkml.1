Return-Path: <linux-kernel-owner+w=401wt.eu-S933408AbXBCBTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbXBCBTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXBCBTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:19:16 -0500
Received: from terminus.zytor.com ([192.83.249.54]:49095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408AbXBCBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:19:15 -0500
Message-ID: <45C3E259.1050908@zytor.com>
Date: Fri, 02 Feb 2007 17:16:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: jbohac@suse.cz
CC: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.753349000@jet.suse.cz>
In-Reply-To: <20070201103753.753349000@jet.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jbohac@suse.cz wrote:
> TSC is either synchronized by design or not reliable
> to be used for anything, let alone timekeeping.

This refers to eliminating the offset between multiple synchronized TSCs.

	-hpa
