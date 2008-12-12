Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYLLUrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYLLUrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYLLUrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:47:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:52122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYLLUra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:47:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jc/yWDp/4ktgJVWunqUif6uYThy3jVRNkTS00WmLdTuQnUQZj6lbqKTGEU1kPEmr0p
         3Xvl2Sp3JHnhCJDKSrbc2sik16/F1WHe6h2SbPPgiDepU4f0EPhHtPFlg8O42rlcI7dX
         Y5KyECswGbuF9lIP8ahi8kkPkIp9T6T5E8MsM=
Date: Fri, 12 Dec 2008 23:47:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081212204724.GA26194@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229113167.32623.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven Rostedt - Fri, Dec 12, 2008 at 03:19:27PM -0500]
| 
... 
| > 
| > Ah, the patch is on top of -tip e3bdf48
| 
| If you have tested this with and without dynamic ftrace, for both the
| function tracer and the function graph tracer, then you have my...
| 
| Acked-by: Steven Rostedt <srostedt@redhat.com>
| 
| -- Steve
...

Thanks Steven! Actually just catched a bug :) I placed
these macros under CONFIG_DYNAMIC_FTRACE but have them
used even if it was undefined -- will fix shortly.

Well... I think the macros should be placed in differen
location (maybe in header) to not overload the source.

		- Cyrill -
