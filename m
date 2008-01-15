Return-Path: <linux-kernel-owner+w=401wt.eu-S1754439AbYAOIqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbYAOIqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYAOIqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:46:18 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:8259
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYAOIqR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:46:17 -0500
Message-Id: <478C8102.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 15 Jan 2008 08:46:42 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <ak@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [19/31] CPA: Limit cache flushing to pages that
	really change caching
References: <200801141116.534682000@suse.de>
 <20080114221651.EDD3A14F83@wotan.suse.de>
In-Reply-To: <20080114221651.EDD3A14F83@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>+static unsigned short pat_bit[5] = {

Could be const and perhaps even local to cache_attr_changed()...

Jan

