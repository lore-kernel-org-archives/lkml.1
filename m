Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYAXVIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYAXVIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYAXVIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:08:04 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33878 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYAXVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:08:01 -0500
Date: Thu, 24 Jan 2008 22:08:00 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h (updated)
In-Reply-To: <20080124205434.GC31333@Krystal>
Message-ID: <Pine.LNX.4.64.0801242206300.12676@fbirervta.pbzchgretzou.qr>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca>
 <Pine.LNX.4.64.0801242137020.12676@fbirervta.pbzchgretzou.qr>
 <20080124205434.GC31333@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 15:54, Mathieu Desnoyers wrote:
>
>Add initialization of an array, which needs brackets that would pollute kernel
>code, to kernel.h. It is used to declare arguments passed as function parameters
>such as:
>text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);
>
>Changelog :
>- [len] -> []
>- Remove whitespaces.
>- Fixed Jan's suggestion which was not checkpatch.pl-safe.

diff -dpru /dev/null <(echo '  #define INIT_ARRAY(type, val, len) ((type[]){[0 ... (len)-1] = (val)}) ') | scripts/checkpatch.pl -
ERROR: Missing Signed-off-by: line(s)
total: 1 errors, 0 warnings, 2 lines checked

Where did checkpatch play unfair again on your side? :)

