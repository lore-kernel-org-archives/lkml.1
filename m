Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZJWMdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZJWMdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZJWMdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:33:24 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:35603 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbZJWMdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:33:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUHAC8+4UpGGN1W/2dsb2JhbACBUJo2vGiEPwSBXQ
Date: Fri, 23 Oct 2009 08:33:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: sparc64 cmpxchg is not a full memory barrier anymore ?
Message-ID: <20091023123327.GA14058@Krystal>
References: <20091022183242.GA19307@Krystal> <20091022.145645.249762938.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091022.145645.249762938.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:32:24 up 65 days, 23:21,  2 users,  load average: 0.69, 0.28,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Thu, 22 Oct 2009 14:32:42 -0400
> 
> > The same applies to the other atomic instructions we find in this list.
> > How is the correct ordering of loads wrt to cmxchg (and other atomic
> > ops) still ensured by this modification?
> 
> All actual sparc64 chips implement more strict ordering than
> the V9 specification permits.  The memory barriers were just
> nops and actually not doing anything more than the chip
> already does for us.

OK. Perhaps adding a comment to that effect near sparc mb()
implementation would be appropriate ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
