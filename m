Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYI3JwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYI3JwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYI3Jvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:51:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:25059 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYI3Jvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K/OL++p/K0Wl3wPQL8MBVKfYIo6gg2q65gt6+OKinpwQD5HE89ITE1OESlSOcvLeEj
         Z6far6M16jdriKhIqh3gfdT0BBI2VMcQgIzaLRWwHU2dN1gP32Q+KPJV0AZwpgRokwIq
         ONtcUKzcFDgUMX7TXQugdJsZ4sMYzX9hzP4bg=
Message-ID: <ca0148c30809300251y37070034m20efd3e65caa868e@mail.gmail.com>
Date: Tue, 30 Sep 2008 12:51:52 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: [patch v1.2.34] WAN: merge driver retina
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <48CC57EB.9010500@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ca0148c30807032339o4182fbadq370f709a28861053@mail.gmail.com>
	 <489A96B2.4030903@pobox.com>
	 <ca0148c30808072334w5d2d8216s37152621b4aa8ebf@mail.gmail.com>
	 <ca0148c30808120246w5c2eca09u3bfa08e3ea40cfe4@mail.gmail.com>
	 <48CC57EB.9010500@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/14 Jeff Garzik <jgarzik@pobox.com>:
> Changes look good, but do not apply to the 'retina' branch.  Also, the
> virt_to_bus/virt_to_phys stuff should be replaced with DMA mapping API
> usage.

Actually there is one call of virt_to_phys in the patch I sent.
I don't know any way to replace virt_to_phys and still use remap_pfn_range.
If all architectures support virt_to_phys, I see no reason to replace it with
something else. The driver is legacy.
