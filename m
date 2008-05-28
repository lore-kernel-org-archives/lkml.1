Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbYE1Ro0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbYE1Ro0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYE1RoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:44:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYE1RoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:44:18 -0400
Message-ID: <483D99CA.8050802@zytor.com>
Date: Wed, 28 May 2008 10:43:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
References: <1211995212.3445.52.camel@localhost.localdomain>
In-Reply-To: <1211995212.3445.52.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> 
> but there are many more.  The greatest problem, as I see it is that by
> pouring vitriol like this on newbies, we're really damaging our
> reputation as a community that welcomes newcomers and strangling our
> necessary supply of willing volunteers.  On the other hand, as a
> maintainer, when there's people yelling me at about patches not being
> included plus a persistent regressions list and about ten bug reports to
> track down, the last thing I want to see within a million miles of my
> inbox is a white space fixing patch.  The more of these patches we get,
> the worse the problem becomes and the shorter and more inflammatory the
> responses get. We can't go on like this.
> 

As far as whitespace fixes, it seems we should just declare a flag day, 
specifically, right before Linus releases 2.6.26 or .27 he'd run 
"cleanfile" on the WHOLE TREE and check it in (either as one patch or 
several.)

After that, one would either have to use "patch -l" to refresh patches 
across the flag day, or I would write a reverse version of "cleanpatch" 
(one which cleans the minus lines and the context instead of the output) 
to fix them up.

Then the whole tree would be whitespace-clean, it would concentrate the 
pain to a single event, and then we can go on with life.

	-hpa
