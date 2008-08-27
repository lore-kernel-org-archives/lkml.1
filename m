Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYH0Xed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYH0Xed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYH0XeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:34:23 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:54868 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753690AbYH0XeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:34:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DILKheBU077W4QPaeEgYngmxxc8m16KposHgKCKpObT6TlA09LQW4PzlOLqs4a7GNHLYXbmR+DsXSzSYjIfQWg5/b0ACcnKFfm4+r1TnN63cz/zfC4fHs8IGVEVCxnNX;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] hotplug/rpaphp: remove unused error path code
Date: Wed, 27 Aug 2008 16:34:03 -0700
User-Agent: KMail/1.9.9
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linda Xie <lxie@us.ibm.com>
References: <20080819114555.c0d2bd50.sfr@canb.auug.org.au>
In-Reply-To: <20080819114555.c0d2bd50.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271634.06199.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 18, 2008 6:45 pm Stephen Rothwell wrote:
> Commit f46753c5e354b857b20ab8e0fe7b2579831dc369 ("PCI: introduce pci_slot")
> removed the need for this error path.  Eliminate this warning:
>
> drivers/pci/hotplug/rpaphp_slot.c: In function 'rpaphp_register_slot':
> drivers/pci/hotplug/rpaphp_slot.c:151: warning: label 'sysfs_fail' defined
> but not used
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied to linux-next, thanks.

Jesse
