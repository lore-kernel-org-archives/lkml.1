Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYLYC1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYLYC1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 21:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYLYC1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 21:27:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:6368 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYLYC1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 21:27:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=QZ0PZ6lhDTNDo/WaIAbsoI5bABe2htDX3Bt/fah+XHYzHfbLm+vL013gKl+kGv6PQk
         aFl8rJFAF1eRHP2YCkUGBrEY9x75y7qxp5ygFmS1yKtXAxGpdV3CmnxrwD02mI+Xvq/k
         Cu3+co454R7HYTxayrK7T59dW3NcDX6Nx84Xc=
Message-ID: <f7848160812241827s39063b23t6a9eac12fdec6708@mail.gmail.com>
Date: Wed, 24 Dec 2008 21:27:37 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: thanasis@asyr.hopto.org
Subject: Re: Sil 3132 SATA II express card
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanasis <thanasis <at> asyr.hopto.org> writes:

>
> I have compiled in kernel (2.6.27) support for Sil 3132:
> CONFIG_SATA_SIL24=y
>
> When I insert the card in the laptop's slot, dmesg shows nothing new.
> Is this normal?
>

Last time I tried that I had to modprobe the pcie hotplug module
(pciehp?) before inserting the card and even then it only worked some
times.

If you boot with the card plugged in that should work - I haven't
tried lately but pciehp was flaky on my hardware (MacBook  Pro).

Parag
