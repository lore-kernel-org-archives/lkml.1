Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbZCTCYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbZCTCYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZCTCX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:23:57 -0400
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:57444 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750831AbZCTCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:23:56 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 22:23:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GvKNkr+SXKX5Mupolpjr8RgGw0Ut21Plil0vyMhaaanQ+mOKcRF4vH+4+2HnRsDpsISIsliW1lD7W+qm0CyDEQRORgl0XwE15XNQTZ+gfCF6CHOHLeFjrl1K/pfiSw1i;
Date: Thu, 19 Mar 2009 19:17:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Compaq Evo D510 SMBus quirk using USB instead of
 VGA
Message-ID: <20090319191713.3400c98b@hobbes.lan>
In-Reply-To: <20090302095113.46661b9d@hyperion.delvare>
References: <20090302095113.46661b9d@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 09:51:13 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> From: David O'Shea <dcoshea@hotmail.com>
> Subject: PCI: Compaq Evo D510 SMBus quirk using USB instead of VGA
> 
> On the Compaq Evo D510 SFF/CMT, a PCI quirk activated the SMBus device
> based on detection of the on-board VGA controller, but the on-board
> VGA is disabled if an AGP card is inserted, so look for one of the USB
> controllers instead.
> 
> Signed-off-by: David O'Shea <dcoshea@hotmail.com>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>

Applied to my linux-next branch, thanks guys.

-- 
Jesse Barnes, Intel Open Source Technology Center
