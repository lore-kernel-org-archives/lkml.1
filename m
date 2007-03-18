Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbXCRH7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbXCRH7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 03:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXCRH7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 03:59:06 -0400
Received: from gw.goop.org ([64.81.55.164]:53943 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbXCRH7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 03:59:04 -0400
Message-ID: <45FCF147.30409@goop.org>
Date: Sun, 18 Mar 2007 00:59:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rusty@rustcorp.com.au, mingo@elte.hu, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       anthony@codemonkey.ws, torvalds@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070316.023331.59468179.davem@davemloft.net>	<45FB005D.9060809@goop.org>	<1174127638.8897.75.camel@localhost.localdomain> <20070318.003309.71088169.davem@davemloft.net>
In-Reply-To: <20070318.003309.71088169.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> The idea is _NOT_ that you go look for references to the paravirt_ops
> members structure, that would be stupid and you wouldn't be able to
> use the most efficient addressing mode on a given cpu, you'd be
> patching up indirect calls and crap like that.  Just say no...
>
> Instead you get rid of paravirt ops completely, and you call functions
> whose symbol name will not resolve in the initial kernel link.
>   

Yeah, I came to that conclusion after thinking about it for a while. 
Thanks for the pointer to the sparc stuff; it looks very interesting.

    J
