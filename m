Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXLLI45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXLLI45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbXLLI4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:56:47 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:41189 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756265AbXLLI4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:56:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=S0Ocxijqb7ZJXWVLvq94uo5Sgq4Phwk21ykDoIvnYemWyN2jeSSrJmG4embwennQMKE84/ipxUxGJ4aMKUfUFsd7gac3TLdNFRdoE5KMO2oDhV6YHz7Xn0vTgz7s0Uvbb9rHgFg2gK3juMo2/tgzi4hUWBW23YHKNWO8Iu5loQQ=;
X-YMail-OSG: oL3HntIVM1kcuzFyEZtjLMGyiDV4a49SJNcvbAHsFHI9wJbZTeYTPppC_u8BhVuvZxLp.wvAbuucphx1geUuyWQ8ul1G1lXDMr9VcfveeWrUtnw3Jqs.h0loYTGUHyCAGlH_xS2IXhRMai3e7YzMGig92g--
Date: Wed, 12 Dec 2007 08:56:44 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20071211171106.ec6f6d38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <788286.65300.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> It might be interesting to see what value of `i' is causing it to fall over.

I tried unrolling the loop, but a single byte read for i = 0 is enough to lock things up.

> Did any earlier version of the 2.6 kernel work OK?

Unfortunately, I don't know. I swapped this card out of the old 2.4.x machine into a machine
already running Fedora 7. The card works when I put it back into the 2.4 machine too, so it's not
a hardware problem with the card.

So I suppose the next step would be trying a linux 2.6.0 kernel? Or was hostap included in the
kernel later than that?

Cheers,
Chris




      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
