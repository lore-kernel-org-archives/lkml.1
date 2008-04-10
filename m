Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYDJHbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYDJHbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 03:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYDJHbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 03:31:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57861 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbYDJHbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:31:42 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
References: <20080409150829.855195878@polymtl.ca>
In-Reply-To: <20080409150829.855195878@polymtl.ca>
Subject: RE: [patch 00/17] Text Edit Lock and Immediate Values for 2.6.25-rc8-mm1
Date: Thu, 10 Apr 2008 16:31:42 +0900
Message-ID: <002801c89adc$ec4533e0$c4cf9ba0$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ja
Thread-Index: AciaX6dVxrwAeiuiR9Gs+2RmJhIM1gAfSwcA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu

> Here is the complete patchset required to get basic Immediate Values 
> support ported to 2.6.25-rc8-mm1. It provides the "simple", non 
> nmi-safe version of immediate values, which means that immediate 
> values should not be used in code paths reachable by NMI or MCE 
> handlers. This version also uses
> stop_machine_run() for immediate values updates, which is a very heavy 
> lock.  In order to make incremental, easy to review, changes, I think 
> we could start by this "simple" version as a first step before we 
> switch to the nmi-safe version later.

I am interested in the performance improvement of "marker."
It is important in arguing that it is "simple."
I will help debug and testing.

Thanks




