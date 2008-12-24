Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbYLXJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbYLXJBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 04:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYLXJBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 04:01:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:33406 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYLXJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 04:01:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Va26tDyKK4aijfaXdOznJog0m6HzKSBLzqIhuM2hxWDb6+sfR1ktgiTMXKAWEcqb2M
         cpj/pb7S9b169VjiIdyAk5XKRMTcQs55joETwhsKO0wDSDBerO4zJlFekaHPWNRjFR4H
         xm3fWFqUDezn4WtD02OYyW9f2AL92yo2Uq3bU=
Message-ID: <df9815e70812240101q23f6d59fj4121b19563a77d47@mail.gmail.com>
Date: Wed, 24 Dec 2008 17:01:01 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] PCI/MSI: bugfix/utilize for msi_capability_init()
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
In-Reply-To: <4951F258.6040601@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4951F258.6040601@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 4:27 PM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> This patch fix a following bug and does a cleanup.
>
> bug:
>        commit 5993760f7fc75b77e4701f1e56dc84c0d6cf18d5
>        had a wrong change (since is_64 is boolean[0|1]):
>
> -               pci_write_config_dword(dev,
> -                       msi_mask_bits_reg(pos, is_64bit_address(control)),
> -                       maskbits);
> +               pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
>
Yes, really a nasty bug. I'm feeling guilty...
Should this fix hit 2.6.28 release?  I CCed Jesse for his point.

-- 
Thanks,
Jike
