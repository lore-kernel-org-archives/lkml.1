Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbZGIXge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbZGIXge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZGIXg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:36:27 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:53482 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZGIXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W0V0685ppHMQoXU4jm47esHUyUTvSIR872iIHc/QIIDWU9k3/QJJH8t5CpH0s3mhFF
         U0+hSMaeesDs1ZBrVkg8oC6RFZQhPdMQ1R1Hma4dAi1k38x1Q5aTnOw/dxrItmJeKfLV
         a+/KNO5PZ/Kt6D2hrxKsWQiPz9AgVc+K+obNU=
Message-ID: <4A567F52.1040505@gmail.com>
Date: Thu, 09 Jul 2009 17:37:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: lkml@MoreThan.org
CC: linux-kernel@vger.kernel.org
Subject: Re: EHCI, BIOS handoff warning/error?
References: <200907090857.47350.lkml@morethan.org>
In-Reply-To: <200907090857.47350.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2009 07:57 AM, Michael S. Zick wrote:
> Anyone with thoughts on this one?
> Even a translation of the message might help.
>
> pci 0000:00:01.0: disabling DAC on VIA PCI bridge
> pci 0000:00:10.0: uhci_check_and_reset_hc: legsup = 0x2000
> pci 0000:00:10.0: Performing full reset
> pci 0000:00:10.1: uhci_check_and_reset_hc: legsup = 0x2000
> pci 0000:00:10.1: Performing full reset
> pci 0000:00:10.2: uhci_check_and_reset_hc: legsup = 0x2000
> pci 0000:00:10.2: Performing full reset
> pci 0000:00:10.4: EHCI: BIOS handoff
> pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> pci 0000:01:00.0: Boot video device

That would mean the BIOS failed to indicate it has given up control of 
the EHCI controller within the allowed time period.
