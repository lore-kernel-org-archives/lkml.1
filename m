Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZK2VJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZK2VJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZK2VJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:09:23 -0500
Received: from khc.piap.pl ([195.187.100.11]:39947 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbZK2VJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:09:23 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jeff Garzik <jeff@garzik.org>
Cc: Stefan Assmann <sassmann@redhat.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Don Dutile <ddutile@redhat.com>, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
References: <4B110F79.8080405@redhat.com> <4B111ADC.9020800@garzik.org>
	<4B123A34.5090509@redhat.com> <4B126EEB.1040908@garzik.org>
Date: Sun, 29 Nov 2009 22:09:26 +0100
In-Reply-To: <4B126EEB.1040908@garzik.org> (Jeff Garzik's message of "Sun, 29
	Nov 2009 07:54:03 -0500")
Message-ID: <m34ood6nsp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Think about this from an engineering perspective.  This patch is
> driven not by any real technical need, but more by marketing and
> trademark folks.

Uh, I'm not sure about this. It would be much better if the kernel was
consistent in naming the PCI versions, not like today: PCIe, PCIE,
PCI-E, PCI-express, PCI-X, PCIX etc, including the user-visible cases
(but obviously not the EDD and similar things).

But I think it should be handler by individual maintainers.

> Finally, split your patch up.  I would suggest starting with 100%
> comment changes that are guaranteed with mathematical certainty to not
> change the compiler-generated code at all.  That will make the
> remaining changes much easier to review, if they are in separate
> patches from the comment-only changes.

Absolutely. Perhaps that older PCI patch should be done first, it was
a good one IIRC.
-- 
Krzysztof Halasa
