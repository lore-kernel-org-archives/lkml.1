Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZJ1V5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZJ1V5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJ1V5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:57:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:18486 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZJ1V5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=nfm0oEd3cr1aRUHxd64vurxUuZdd4ssgPB748vNt0Jp5xaKwk8WmqqPki4DTchS8co
         Kk4tScXvy/uwofHk6hmUucv5gwsjl5YVKpKxjOIMDxlXaOs8Fqhkihg4GI4oxdK4Hlua
         xpcZpSUzdGya06R1hzkiGR18mdmW0qzTd+I8Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-next-2.6 2009-10-28
Date: Wed, 28 Oct 2009 22:56:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091028211031.GF2856@tuxdriver.com>
In-Reply-To: <20091028211031.GF2856@tuxdriver.com>
MIME-Version: 1.0
Message-Id: <200910282256.00407.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 October 2009 22:10:32 John W. Linville wrote:
> Dave,
> 
> I let my patches pile-up!  Yikes!!
> 
> This request includes the usual ton of stuff for -next -- driver
> updates, fixes for some earlier -next stuff, a few cfg80211 changes to
> accomodate the libertas driver, etc.  Of note is the rt2800pci support
> added to the rt2x00 family.

Unfortunately rt2800pci support is non-functioning at the moment... :(

> Pleaset let me know if there are problems!

I find it rather disappointing that all my review comments regarding
rt2800pci support were just completely ignored and then the initial
patch was merged just as it was..

The way rt2800usb and rt2800pci drivers are designed really results
in making the task of adding working support for RT28x0 and RT30x0
chipsets to rt2x00 infrastructure more difficult and time consuming
than it should be... :(

-- 
Bartlomiej Zolnierkiewicz
