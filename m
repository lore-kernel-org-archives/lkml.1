Return-Path: <linux-kernel-owner+w=401wt.eu-S1762162AbXK2Av3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbXK2Av3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXK2AvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:51:22 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56463 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbXK2AvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:51:21 -0500
Date: Thu, 29 Nov 2007 01:51:20 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: tvrtko.ursulin@sophos.com
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
Message-ID: <Pine.LNX.4.64.0711290147181.22052@fbirervta.pbzchgretzou.qr>
References: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 28 2007 18:22, tvrtko.ursulin@sophos.com wrote:
>
>Talpa is modular itself being composed of a set of kernel modules of which 
>not all are loaded simultaneously. Where possible LSM can be used and _no_ 
>messing with syscall table will take place. Unfortunately where another 
>LSM user is present that won't work

SELinux supports chaining, so if talpa is loaded as a secondary to selinux,
where is the problem? For those LSMs which do not support chaining (*cough*
apparmor *cough* be one, mtadm another), fix them.

