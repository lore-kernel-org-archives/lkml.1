Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYA1FXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYA1FXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYA1FXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:23:14 -0500
Received: from qb-out-0506.google.com ([72.14.204.230]:61901 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYA1FXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:23:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=Dt0ILj30MnYcmJ/uj6uRjYNURyhDj/Eb+WHyINYwNhz/Hbrm5ivZoA6uB1Un9RU8t7enhLc68sxNM/y6gLfL904ZG4BZ+zqpf4HorO2DIBzc1KVGmzIq1eDLSEr1tpUiMbuv4B/M6Qa77wLoeR5lv+GA1Z+53N49rC9q+oyDV7s=
Date: Mon, 28 Jan 2008 13:20:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Garzik <jeff@garzik.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: (Updated) [Patch] Shut up warnings from files under drivers/
Message-ID: <20080128052044.GB3099@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org> <20080127041521.GC2495@hacking> <479C49F4.8060800@gmail.com> <479C4D08.4020800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <479C4D08.4020800@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 10:21:12AM +0100, Jiri Slaby wrote:
>On 01/27/2008 10:08 AM, Jiri Slaby wrote:
>>On 01/27/2008 05:15 AM, WANG Cong wrote:
>>>Fix defined-but-not-used warnings from files under drivers/,
>>>such as:
>>>
>>>drivers/char/applicom.c:68: warning: ‘applicom_pci_tbl’ defined but 
>>>not used
>>>
>>>Compile tests passed.
>>>
>>>Cc: Jeff Garzik <jeff@garzik.org>
>>>Cc: Greg KH <gregkh@suse.de>
>>>Cc: Sam Ravnborg <sam@ravnborg.org>
>>>Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>>>
>>>---
>>>
>>>diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
>>>index 1f0b752..97171ad 100644
>>>--- a/drivers/char/applicom.c
>>>+++ b/drivers/char/applicom.c
>>>@@ -65,7 +65,7 @@ static char *applicom_pci_devnames[] = {
>>>     "PCI2000PFB"
>>> };
>>> 
>>>-static struct pci_device_id applicom_pci_tbl[] = {
>>>+static struct pci_device_id applicom_pci_tbl[] __used = {
>>>     { PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
>>>       PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>>     { PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
>>
>>I have probably a better fix with pci_match_id() referencing this array.
>
>Hmm, checking it one more time persuades me that the best fix ever is to 
>convert it to probing. David, do you have the card?

OK. I will drop this part.

