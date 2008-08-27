Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYH0Xd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYH0Xd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYH0Xdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:33:46 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:35336 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755578AbYH0Xdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:33:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=AfBI6qN9PYVJCLegSL6ResLC0hDcPx3I2a8y4dQOJm6Wi2SF9zO7xr2aSH8MgFFg6+d3BLlaFGQ6odNHoNiER3mm2MTUtAzmEVAjAHJvM1ux1YTZwq0re1g1eM2wINTo;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Petazzoni <thomas.petazzoni@enix.org>
Subject: Re: [PCI] Configure out PCI quirks
Date: Wed, 27 Aug 2008 16:33:35 -0700
User-Agent: KMail/1.9.9
Cc: thomas.petazzoni@free-electrons.com, michael@free-electrons.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1KVMZk-0004qG-W9@surf>
In-Reply-To: <E1KVMZk-0004qG-W9@surf>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271633.36450.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 19, 2008 1:28 am Thomas Petazzoni wrote:
> [PCI] Configure out PCI quirks
>
> This patch adds the CONFIG_PCI_QUIRKS option which allows to remove
> all the PCI quirks, not necessarly used on embedded systems when PCI
> is working properly. As this is a size-reduction option, it depends on
> CONFIG_EMBEDDED. It allows to save almost 12 kilobytes of kernel code:
>
>    text	   data	    bss	    dec	    hex	filename
> 1287806	 123596	 212992	1624394	 18c94a	vmlinux.old
> 1275854	 123596	 212992	1612442	 189a9a	vmlinux
>  -11952       0       0  -11952   -2EB0 +/-
>
> This patch has originally been written by Zwane Mwaikambo
> <zwane@arm.linux.org.uk> and is part of the Linux Tiny project.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

12k's not to shabby.  I put this in linux-next, thanks Thomas.

Jesse
