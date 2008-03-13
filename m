Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYCMBBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYCMBBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYCMBBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:01:40 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53899 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYCMBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:01:40 -0400
Message-Id: <20080313002235.351414762@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Mar 2008 01:22:35 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 0/4] [RFC] cleanup 64bit divide API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The primary purpose of these patches is to introduce a signed divide,
which is useful for NTP. While I'm at it I cleaned up the API, so it
should be a little easier to use.
It uses a new header <linux/math64.h> for it instead of using
<asm-generic/div64.h>. asm-generic/div64.h has the problem of an
all-or-nothing approach, so any arch not using it has to implement the
whole API and usually it's enough to provide only one of them.
<linux/math64.h> allows to selectively functions as needed.

In the long term we can first depricate using <asm/div64.h> and even
later do_div() completely.

bye, Roman

-- 

