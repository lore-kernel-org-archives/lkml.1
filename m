Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZBNLlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZBNLlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 06:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZBNLl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 06:41:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:32490 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZBNLl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 06:41:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HS4JCMRcBJIb1V2Oe1Mn34tdf2Y7cZ9xS763Hpa1HFzt2gioDBAZ3eaCMXCtf805mv
         DOKwfrFZAVhScOBWpCGxe6OEpbqTtNYHNNyqXAKOcKw7TPNAb+GydWRiOhQ9XJ038cHr
         k2uomd5p1d7jhiWdtd0nIr3ArveCwA/R7hZeg=
MIME-Version: 1.0
In-Reply-To: <pWZw1SZjMCH.A.zq.WwYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.zq.WwYiJB@chimera>
Date: Sat, 14 Feb 2009 19:41:25 +0800
Message-ID: <b6a2187b0902140341y2a1da743o7b012e6386583a62@mail.gmail.com>
Subject: Re: [Bug #12414] iwl4965 cannot use "ap auto" on latest 2.6.28/29?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       reinette.chatre@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 6:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12414
> Subject         : iwl4965 cannot use "ap auto" on latest 2.6.28/29?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-05 4:13 (31 days old)
> References      : http://marc.info/?l=linux-kernel&m=123112882127823&w=4

I applied the patch
http://marc.info/?l=linux-wireless&m=123320213115108&w=2 and it seems
better now. One instant of not association out of 20 tries, but
reloading the modules seems to make it work again. So, let's just
close the case?


Here's part of the dmesg. Kernel is 2.6.29-rc5 with patch above applied.

wmaster0 (iwlagn): not using net_device_ops yet
phy0: Selected rate control algorithm 'iwl-agn-rs'
wlan0 (iwlagn): not using net_device_ops yet
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
iwlagn loaded firmware version 228.57.2.23
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
iwlagn: TX Power requested while scanning!
iwlagn: Error sending TX power (-11)
wlan0: authenticate with AP xxxxxxxxxxxxx
wlan0: authenticated
wlan0: associate with AP xxxxxxxxxxxxxx
wlan0: RX AssocResp from xxxxxxxxxxxxxx (capab=0x471 status=0 aid=24)
wlan0: associated


Thanks,
Jeff.
