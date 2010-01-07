Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741Ab0AGEwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0AGEwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510Ab0AGEww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:52:52 -0500
Received: from ozlabs.org ([203.10.76.45]:42556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0AGEww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:52:52 -0500
Date: Thu, 7 Jan 2010 15:52:48 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Counting FP multiplies on Core 2
Message-ID: <20100107045248.GB30718@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel manual tells me that event num 12H, umask 00H on Core 2
counts multiply operations executed, but says "Use IA32_PMC1 only".
Is there a way in the raw event code to specify a particular PMC, or
does the code just know that that event can only be counted on PMC1?

Paul.
