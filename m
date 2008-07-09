Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYGIMLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYGIMLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYGIML1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:11:27 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:7736 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYGIML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LlCOnG7KzeurEzrRbrPIzYlTt/7wUa9Lep/2S/ziaPni4WC1BvlMLVbQEmtiCFoVRT
         EtTbf4ALH8pH11x1Dq9b+cqX6yeCnMBxGfuG/ypwbGRA6jDbRFYdlnLEeOY0oEFw1E5y
         23fNW5FRbYRZJLoZ4i3Hu7Bk+Z3xEdWA+Ibas=
Subject: Re: [PATCH 03/04] resource: use new resource type changes
From: Josh Boyer <jwboyer@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
In-Reply-To: <20080709115452.14144.28953.sendpatchset@rx1.opensource.se>
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
	 <20080709115452.14144.28953.sendpatchset@rx1.opensource.se>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 08:11:13 -0400
Message-Id: <1215605473.13186.2.camel@weaponx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 20:54 +0900, Magnus Damm wrote:
> Make sure resource_type() or IORESOURCE_TYPE_BITS are used instead of
> bit operations. This needs more work, I ignored drivers/ for now.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---

<snip>

>  arch/ppc/kernel/pci.c                      |   48 +++++++++++++---------------
>  arch/ppc/syslib/ppc405_pci.c               |    2 -
>  arch/ppc/syslib/ppc_sys.c                  |    2 -

You can drop the arch/ppc bits entirely.  arch/ppc won't exist in 2.6.27

josh

