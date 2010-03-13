Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936451Ab0CMB2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:28:36 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:38752 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934901Ab0CMB22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 20:28:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IhkEejdgsKxbmSVJySd6mEojNOsHklqPQd9akTUy1J2n1kQcodYuqDLgwfUzA39SAjL+jtT4mfX3PTKF2KSIZzniHdr7W3X2LwVBwtUNQ/bmG1PfMGwK+S5oDUseKULV;
Date: Fri, 12 Mar 2010 17:27:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chihau Chau <chihau@gmail.com>
Cc: rjw@sisk.pl, kaneshige.kenji@jp.fujitsu.com, yu.zhao@intel.com,
       bjorn.helgaas@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chihau Chau <chihau@gmail.com>
Subject: Re: [PATCH] Drivers: pci: code style cleanup
Message-ID: <20100312172738.522f435f@jbarnes-piketon>
In-Reply-To: <1268329983-2603-1-git-send-email-chihau@gmail.com>
References: <1268329983-2603-1-git-send-email-chihau@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 14:53:03 -0300
Chihau Chau <chihau@gmail.com> wrote:

> From: Chihau Chau <chihau@gmail.com>
> 
> This is a code style cleanup related with spaces, like a lot of trailing
> withspaces, spaces before a TAB, to use "foo * bar" instead of "foo *bar"
> and to put a else sentence below close brace '}'.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

Unless you're doing some other work in this area and include this patch
in a larger patchset, I'm inclined to reject it, since it just creates
churn for others for no good reason.

In other words, if developer A is making real changes in these areas
that would invalidate developer B's patches, that's fine.  But I don't
think it's ok to let cleanup patches invalidate developer B's work.

Hope that's clear.  Don't get me wrong, I like the fact that in Linux
we're not afraid to clean stuff up.  I just don't like it getting in
the way of real work.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
