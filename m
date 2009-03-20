Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbZCTBul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbZCTBul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZCTBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:50:28 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:37731 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757381AbZCTBu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:50:27 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 21:50:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lC7p3+xpJy/oNkpGM7ORGcbNmeMumzACf0/8wII9c1aOkxwG6nMlNZ5/obqaHAFGPLzJqFS2YPeTL8kmVxymHj+ecyCllfAVp1SwVmGwkjyorlrp6Ci5gO4tr+hy5G/3;
Date: Thu, 19 Mar 2009 18:43:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: rjw@sisk.pl, linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCIe portdrv: eliminate double kfree in remove path
Message-ID: <20090319184344.286b557e@hobbes.lan>
In-Reply-To: <20090309180815.GH32589@ldl.fc.hp.com>
References: <20090309180815.GH32589@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009 12:08:15 -0600
Alex Chiang <achiang@hp.com> wrote:

> Commit 55633af3 (PCIe portdrv: Use driver data to simplify code)
> added a kfree of the driver private data in pcie_port_device_remove
> but forgot to remove the old kfree from pcie_portdrv_remove.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
