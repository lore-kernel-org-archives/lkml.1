Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYGBLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYGBLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYGBLVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:21:22 -0400
Received: from kuber.nabble.com ([216.139.236.158]:44949 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYGBLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:21:22 -0400
Message-ID: <18235306.post@talk.nabble.com>
Date: Wed, 2 Jul 2008 04:21:21 -0700 (PDT)
From: yzhar <yzhar@varonis.com>
To: linux-kernel@vger.kernel.org
Subject: How to figure READONLY kernel space address/page
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: yzhar@varonis.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi there,

I would like to figure out if a kernel space address is within a READONLY
page (even for kernel usage).
The code is within an LKM, so I guess I'm a bit constraint to exported
kernel methods.
I can see the pgtbl entry holding such information, but could not figure out
how to get pte_t* from a kernel address.

One other thing I'm confused with is "what methods/symbols could I use
within an LKM"? (The LKM is build out of kernel build).
Some articles suggested the /proc/kallsyms searching for the _T_ symbols,
but from my short experience it doesn't correspond.
Could you enlighten this issue? 

Btw,
I'm very new to the Linux kernel.

Thx,
Yzhar

-- 
View this message in context: http://www.nabble.com/How-to-figure-READONLY-kernel-space-address-page-tp18235306p18235306.html
Sent from the linux-kernel mailing list archive at Nabble.com.

