Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYEPRaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYEPRaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYEPRaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:30:04 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:58803 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832AbYEPRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:30:03 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tcamuso@redhat.com
Subject: Re: [PATCH] PCI: Correct last two HP entries in the bfsort whitelist
Date: Fri, 16 May 2008 10:29:55 -0700
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
References: <482C838E.3030203@redhat.com> <20080515220215.76eea915@core> <482CB7D7.30008@redhat.com>
In-Reply-To: <482CB7D7.30008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161029.55649.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2008 3:23 pm Tony Camuso wrote:
> Alan Cox wrote:
> > This is going to make everyone with those boxes who upgrades suddenely
> > get their devices re-ordered and renamed when the probe order changes.
> > That seems extremely inappropriate.
> >
> > Alan
>
> HP maintains that more of our customers, especially new customers,
> will be adversely affected by NOT implementing this patch for the
> following reasons.
>
> 1. HP issued a Customer Advisory for existing customers to use "pci=bfsort"
>     in the boot command for these systems. Customers using pci=bfsort in
>     their boot scripts will be unaffected by this patch.
>
> 2. Customers using only the two embedded NI devices will be unaffected.
>
> 3. Because of the use of labels for disk devices, they are unaffected.
>
> 4. New customers who must add pci=bfsort to their boot scripts have
>     expressed dissatisfaction.
>
> The only time this patch would induce any confusion for an existing
> customer is upon the convergence of the following situations.
>
> 1. The user has not followed the instructions in the release notes
>     for the DL360 and DL380,
>
>     AND
>
> 2. The user has added NI cards to the option slots,
>
>     AND
>
> 3. The user upgrades his kernel.

Ok, I'll put it in linux-next for now then.  It would be good to hear some 
feedback from users about it though...

Thanks,
Jesse
