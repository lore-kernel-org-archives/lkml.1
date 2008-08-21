Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYHUIYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYHUIYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYHUIX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:23:56 -0400
Received: from eisentraut.org ([85.214.91.16]:60584 "EHLO gattler.pezone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYHUIX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:23:56 -0400
From: Peter Eisentraut <peter_e@gmx.net>
To: Solofo.Ramangalahy@bull.net
Subject: Re: [Bugme-new] [Bug 11381] New: default shmmax
Date: Thu, 21 Aug 2008 11:24:08 +0300
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, matthltc@us.ibm.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>,
       Pierre Peiffer <peifferp@gmail.com>, containers@lists.osdl.org
References: <bug-11381-10286@http.bugzilla.kernel.org/> <20080820120043.e6e7e436.akpm@linux-foundation.org> <18605.8253.81960.581255@frecb006361.adech.frec.bull.fr>
In-Reply-To: <18605.8253.81960.581255@frecb006361.adech.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808211124.10850.peter_e@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solofo.Ramangalahy@bull.net wrote:
> OpenSuse (11.0 at least) has this:
> -#define SHMMAX 0x2000000                /* max shared seg size (bytes) */
> +#define SHMMAX ULONG_MAX                /* max shared seg size (bytes) */

Interesting, I don't see that in SLES 10, so it must be quite new.  If no 
problems are found with this, this would be great for the upstream kernel.
