Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZCTCM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZCTCM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 22:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZCTCMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 22:12:19 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:42111 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753367AbZCTCMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 22:12:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Jge4ndNizTOHq8C078911jTyVzMjcN8YUm8S+m9r8LMau9MFau7fXswqU9iNlKk4EWMwE6A1q0Cdb38vgqwpCB2XMyALva5y2oZjTIXt9NzfjgIoRJvPrhNc0YlYlcZg;
Date: Thu, 19 Mar 2009 19:12:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] pci: expose boot VGA device via sysfs.
Message-ID: <20090319191213.0d52c52d@hobbes.lan>
In-Reply-To: <alpine.DEB.2.00.0903040555490.28485@skynet.skynet.ie>
References: <alpine.DEB.2.00.0903040555490.28485@skynet.skynet.ie>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 05:57:05 +0000 (GMT)
Dave Airlie <airlied@linux.ie> wrote:

> 
> X really would like to know which VGA device was considered the boot
> device by the system. The x86 PCI fixups have support for discovering
> this but we provide no way to expose it to userspace.
> 
> This adds a sysfs file per VGA class device which has the value 0 for
> non the boot device or unknown, and 1 if the VGA device is the boot
> device.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
