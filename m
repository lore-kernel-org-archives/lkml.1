Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbYAaFnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbYAaFnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 00:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYAaFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 00:43:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:36326 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYAaFm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 00:42:59 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Value of __*{init,exit} anotations?
Date: Thu, 31 Jan 2008 06:42:54 +0100
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080130200336.GN29368@does.not.exist> <1201729295.3292.94.camel@localhost.localdomain> <20080130223219.GT29368@does.not.exist>
In-Reply-To: <20080130223219.GT29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310642.54632.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Some people consider it worth it for their memory restricted systems
> and would like to drive the annotations even further. [1]

They could get much better bang-for-the-buck (as in memory saved
for amount of work invested) by tackling some the dynamic memory allocation
pigs.

In general it's a trade off between how much work and patch churn versus
benefit, and some of the annotations really don't look too good on this
scale.

> People at linux-arch (Cc'ed) might be better at explaining how often 
> CONFIG_HOTPLUG gets used in real-life systems and how big the savings 
> are there.

CONFIG_HOTPLUG is widely used for suspend on multi core systems. 

-Andi
