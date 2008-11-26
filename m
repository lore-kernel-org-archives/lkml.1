Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKZTdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKZTdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYKZTdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:33:39 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:26575 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYKZTdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DvrJYLZNZaaLc2B0dmK81C+feKlp/r8FTblhnng7r5MRDVAScRmjofEebjIFqxw8So
         71mp/fRqyDJTQPYGZy2sv6XGlM/Wp09fIRX6WF/YUuNYn1AxLkUc+eDVgNrd7EFZzpCw
         qM4bA7kqHp/5wZIFZL0K6SkxXJp0ThJMsq1p4=
Date: Wed, 26 Nov 2008 22:33:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081126193336.GA2624@localhost>
References: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[gorcunov@gmail.com - Wed, Nov 26, 2008 at 10:17:01PM +0300]
| From: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| Impact: cleanup, microoptimization
| 
| Use straightforward jumping if possible, cpu like it.

Wrong word, not _straight_ forward but forward branch target
in this case.

| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| ---
|  arch/x86/kernel/entry_64.S |   10 ++++------
|  1 files changed, 4 insertions(+), 6 deletions(-)
| 
		- Cyrill -
