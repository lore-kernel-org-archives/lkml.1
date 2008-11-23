Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYKWRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYKWRA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYKWRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:00:14 -0500
Received: from qb-out-0506.google.com ([72.14.204.237]:16938 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYKWRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sB0maq/HulvIgW2xsgZMghBdAk68Kpp3jYdW4wQWaPrzyTvz8GzGy/TbfUJa7X4Wzk
         yIoWHKHejiaGB0KMIJrhAO4kzIHICVQfIATEXWPYfzA0ufIbbo3B1BAp2JwjNp4Q/BTJ
         53QuG/gkPI24WC3I16z3dIVEVrg7l53uvgMqc=
Date: Sun, 23 Nov 2008 20:00:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123170010.GB12710@localhost>
References: <20081123165711.GA12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123165711.GA12710@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Nov 23, 2008 at 07:57:11PM +0300]
| It's usefull to catch unbalanced, missed or mixed declarations of ENTRY and
| KPROBES. These macros would help a bit (at least I hope so).
|
...

Ingo, don't apply it -- found a nit. Will fix.
 
		- Cyrill -
