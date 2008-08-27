Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbYH0Xo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbYH0Xo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYH0Xot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:44:49 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:59306 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753975AbYH0Xot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:44:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=ak2V9g3VwenHcIzKlehx7ie9r7GGfh//vifnYPOFUACZ0IVTRaNn5IreY7b2Rv3cLMz4qmeJgAOXGg0Dejwxj4MT1awsCKYah3ub4t+Skba9ORQfuHZxktDPTmTDrltU;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] PCI PM: Introduce function pci_wake_from_d3 (rev. 2)
Date: Wed, 27 Aug 2008 16:04:59 -0700
User-Agent: KMail/1.9.9
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200808182057.22501.rjw@sisk.pl> <200808182138.00989.rjw@sisk.pl>
In-Reply-To: <200808182138.00989.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271605.01006.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 18, 2008 12:38 pm Rafael J. Wysocki wrote:
> [Sorry, it is more useful to define the function so that it takes a second
> argument indicating whether to enable or disable wake-up.]
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> PCI PM: Introduce function pci_wake_from_d3 (rev. 2)
>
> Many device drivers use the following sequence of statements to
> enable the device to wake up the system while being in the D3_hot
> or D3_cold low power state:
>
> 	pci_enable_wake(pdev, PCI_D3hot, 1);
> 	pci_enable_wake(pdev, PCI_D3cold, 1);
>
> However, the second call is not necessary if the first one succeeds
> (the ordering of the statements above doesn't matter here) and it
> may even be harmful, because we are not supposed to enable PME#
> after the wake-up power has been enabled for the device.
>
> To allow drivers to overcome this problem, introduce function
> pci_wake_from_d3() that will enable the device to wake up the system
> from any of D3_hot and D3_cold as long as the wake-up from at least
> one of them is supported.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Applied to linux-next, thanks Rafael.

Jesse
