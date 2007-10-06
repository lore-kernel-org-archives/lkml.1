Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXJFGKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXJFGKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 02:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXJFGK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 02:10:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:24547 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbXJFGK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 02:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xng+FJk4DILSxG9Ez0nAILYAV99DuTJ9Jyu1IqIsHhNRRRE3YKbWaPKGV1RBwpoxeJYso0WVZwsPfugCylIMnTDwtJglfv4CUl1JhLMFKSugbTffQqoJg7He8BCmQSssVft+1gv4WvchHZ2s+ZWXLUS9+L+HehxUPCTYYWGHnJM=
Message-ID: <19f34abd0710052310r2043f69ew70fe8b5f9ef0493c@mail.gmail.com>
Date: Sat, 6 Oct 2007 08:10:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Cc: "Miguel Ojeda" <maxextreme@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <200710051126.50816.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191528247.13580.11.camel@grianne>
	 <200710042059.25721.rob@landley.net>
	 <653402b90710050001k29ed8e3by1ccc4a0ede818b9f@mail.gmail.com>
	 <200710051126.50816.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Rob Landley <rob@landley.net> wrote:
> The original idea (selectively compile out printk() instances based on log
> level to conserve space) is explicitly not addressed by this patch, and in
> fact this patch might actually make it harder to implement (by complicating
> the code).

This is wrong. The patch provides log-level-based filtering at compile
time, effectively making the kernel smaller.

> *shrug*  That doesn't mean my objections are important to anyone else, just
> that I don't personally see any reason to be enthusiastic about this patch.

I agree; you are right about the other things, Maybe I can try to fit
some of these things into printk itself (thanks for the tip, Alan),
and we'll see how far we can get.

Thanks.

Vegard
