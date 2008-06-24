Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYFXK7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYFXK7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYFXK72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:59:28 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:42122 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbYFXK71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:59:27 -0400
X-Trace: 36937593/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.72.211
X-SBRS: None
X-RemoteIP: 81.1.72.211
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjIFAJNwYEhRAUjT/2dsb2JhbACBW7Eo
X-IronPort-AV: E=Sophos;i="4.27,695,1204502400"; 
   d="scan'208";a="36937593"
Message-ID: <5703.85.118.17.158.1214305147.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20080624040128.GB22526@linux-sh.org>
References: <1213559289.22707.15.camel@localhost.localdomain>
    <20080624040128.GB22526@linux-sh.org>
Date: Tue, 24 Jun 2008 11:59:07 +0100 (BST)
Subject: Re: [PATCH] maple: tidy  maple_driver code by removing redundant 
     connect/disconnect
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Paul Mundt" <lethal@linux-sh.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, June 24, 2008 5:01 am, Paul Mundt wrote:
> On Sun, Jun 15, 2008 at 08:48:09PM +0100, Adrian McMenamin wrote:
>> The connect and disconnect functions are unnecessary - everything they
>> do can be
>> accomplished in the initial probe - so remove them.
>>
>> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
>
> Applied, thanks.
>
Paul,

Just to note that this (http://lkml.org/lkml/2008/6/15/122) will break the
keyboard driver unless this (http://lkml.org/lkml/2008/6/15/121) is also
applied.

I haven't heard back from Dmitry on the keyboard patch yet.

Adrian

