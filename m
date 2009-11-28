Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZK1VRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZK1VRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZK1VRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 16:17:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:48578 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZK1VRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 16:17:18 -0500
Subject: Re: [PATCH v3 16/27] PPC: use helpers for rlimits
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <4B10E385.1030900@gmail.com>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
	 <1259363167-9347-16-git-send-email-jslaby@suse.cz>
	 <1259367557.2076.11.camel@pasglop>  <4B10E385.1030900@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Nov 2009 08:16:03 +1100
Message-ID: <1259442963.2076.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-28 at 09:47 +0100, Jiri Slaby wrote:
> Are you sure? The previous version with ACCESS_ONCE was generally
> NACKed. This one uses a newly added helper which is much more cleaner
> way to do it.

I haven't seen a nack, but then I haven't pushed out yet so I can easily
back it off and replace it with this one.

Cheers,
Ben.


