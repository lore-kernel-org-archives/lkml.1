Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYCYMkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYCYMkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYCYMko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:40:44 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:20282 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbYCYMko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:40:44 -0400
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       ak@suse.de
Subject: Re: [PATCH 45/79] [PATCH] fix apic acking of irqs
References: <12059475744092-git-send-email-gcosta@redhat.com>
	<12059476971309-git-send-email-gcosta@redhat.com>
	<1205947702588-git-send-email-gcosta@redhat.com>
	<12059477063046-git-send-email-gcosta@redhat.com>
	<12059477102394-git-send-email-gcosta@redhat.com>
	<12059477143205-git-send-email-gcosta@redhat.com>
	<1205947719906-git-send-email-gcosta@redhat.com>
	<12059477234148-git-send-email-gcosta@redhat.com>
	<12059477273855-git-send-email-gcosta@redhat.com>
	<1205947732309-git-send-email-gcosta@redhat.com>
	<12059477371787-git-send-email-gcosta@redhat.com>
	<12059477421707-git-send-email-gcosta@redhat.com>
	<12059477472416-git-send-email-gcosta@redhat.com>
	<12059477521176-git-send! -email-gcosta@redhat.com>
	<12059477561937-git-send-email-gcosta@redhat
	<12059477792893-git-send-email-gcosta@redhat.com>
	<alpine.SOC.1.00.0803201016540.12075@piorun>
	<47E27D08.9050809@redhat.com>
	<alpine.SOC.1.00.0803202125520.21415@piorun>
	<47E7C00B.5000503@redhat.com>
	<alpine.SOC.1.00.0803241608310.12757@piorun>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 13:40:41 +0100
In-Reply-To: <alpine.SOC.1.00.0803241608310.12757@piorun>
Message-ID: <87k5jrgenq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 12:34:04.0368 (UTC) FILETIME=[82E86D00:01C88E74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:
> 
>  Please note that ESR may hold some leftover state from whatever happened 
> before Linux has taken control, so it is reasonable and I think actually 
> recommended by Intel (FWIW) to clear the register before enabling the 
> error interrupt.  For how to clear the ESR properly, please see 
> setup_local_APIC() -- subtle differences and errata in various APIC 
> implementations have made it more complicated than necessary, sigh...

iirc a lot of the ESR weirdness was on NUMAQ only, which is down to one 
of two last machines running Linux which will hopefully die soon ...

-Andi

