Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZKRRzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZKRRzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZKRRzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:55:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51863
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757939AbZKRRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:55:10 -0500
Date: Wed, 18 Nov 2009 09:55:26 -0800 (PST)
Message-Id: <20091118.095526.43570583.davem@davemloft.net>
To: jslaby@novell.com
Cc: jirislaby@gmail.com, mingo@elte.hu, nhorman@tuxdriver.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
       jmorris@namei.org, heiko.carstens@de.ibm.com,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 06/16] SPARC: use ACCESS_ONCE for rlimits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1258555922-2064-6-git-send-email-jslaby@novell.com>
References: <4B040A03.2020508@gmail.com>
	<1258555922-2064-6-git-send-email-jslaby@novell.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@novell.com>
Date: Wed, 18 Nov 2009 15:51:52 +0100

> Make sure compiler won't do weird things with limits. E.g. fetching
> them twice may return 2 different values after writable limits are
> implemented.
> 
> Signed-off-by: Jiri Slaby <jslaby@novell.com>

Acked-by: David S. Miller <davem@davemloft.net>

But I wonder have we really seen the compiler create this
kind of situation?  Or is this patch series based upon the
fact that it "could happen"?
