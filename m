Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZA3WcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZA3WcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZA3Wbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:31:55 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:29614 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZA3Wbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=riR9djRKwrznp4AkufKoIAePma7V2lOhYqR7XgNU9EzsphrTotnrPoxXIpHFOoAI7s
         +UQHO1FIrP2UTzUmvaqamp0eHntjC0Nat0qc5qKN4WX9ZPqejVFM/OtQBOxJ7sQZ4HJq
         QJ2gO9oftASz/dWqVGCclhtsppkDVR3zRnhmA=
Date: Fri, 30 Jan 2009 17:31:42 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matt Carlson <mcarlson@broadcom.com>,
       Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <200901300110.56533.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0901301730230.6574@parag-desktop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901300003.38550.rjw@sisk.pl> <20090129234127.GA14023@xw6200.broadcom.net> <200901300110.56533.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Rafael J. Wysocki wrote:

> 
> I still am interested if it makes any difference for Parag.

No difference - tg3 is still dead after resume.

BTW, I applied the patch on top of the one Matt gave earlier.
Machine booted with original tg3 which I rmmod'ed and then insmod'ed the 
new one (with Matt's and Rafael's patch) and then attempted a 
suspend-resume.

Is there a reason to try fresh boot with patched tg3 and without 
loading old module - I guess I will try that one later as well.

Thanks
Parag
