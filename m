Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbZEYLXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbZEYLXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEYLXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:23:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:15501 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZEYLXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Glnt8KHtcpCV3/YNNvoMkjTqHZHRtltKIuhsySU+vSKNT1GXtMvuEO04WY7qhJC2q/
         ng7+QS10n0eL6sKVUD2TiKCf8Oq9dr34+qYHalpa7OGAmQvqRNH0uGMdLVVZPPiNyWtq
         /3oMrE8F7XVKqdD8JK3GdssbX1QIuwTR30QA8=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Mon, 25 May 2009 13:23:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda>
In-Reply-To: <1243247687.5322.8.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905251323.07845.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Alejandro Riveira Fernández wrote:
> I reported it previously but i'm resending it as a regresion
> 
> More info on the bugzilla
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=13362
> 
> I bisected it in the estable tree (it regresses too) and the revert
> helps there but reverting the upstream commit in mainline does not help
> to fix it completely...

Bug 9273 -  rt2500pci: low TCP throughput
	http://bugzilla.kernel.org/show_bug.cgi?id=9273

Bug 443203 -  Fedora rawhide + ralink = slow bit rate
	https://bugzilla.redhat.com/show_bug.cgi?id=443203

[Hardy][Intrepid] Low bandwidth with rt2400 / rt2500 drivers
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/190515

I can't call this a regression, dozens people have reported the problems
ranging from kernels 2.6.25 to 2.6.29. Perhaps in your case it worked slightly
better once, but that was not the case for all other users.

Have you tried the "iwconfig wlan0 rate54M" workaround?

Ivo
