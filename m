Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbYAWRjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbYAWRjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbYAWRiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:38:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbYAWRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ZILuUoOtjiGfk6dxw9b9aDw0AKlzEiPmuXnRMFxFNBqm8vNKP2mmmT28uDJGSmsoBt0nAlYk+2pwriKxLkR9+DJTaA8kOuPcr4llZxoQ/BHT4sCx4G3L0tPbSeRw7/FQN9L2aI3u2wHWej4tigwhnYowMIPlqpqczphL9oAlGZo=
Date: Wed, 23 Jan 2008 20:38:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/6] use KSYM_NAME_LEN instead of numeric values
Message-ID: <20080123173820.GA6740@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series does convert explicitly defined lengths of
buffers being passed to kallsyms_lookup to KSYM_NAME_LEN

		- Cyrill -
