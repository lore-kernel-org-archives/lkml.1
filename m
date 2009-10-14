Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbZJNUu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbZJNUu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbZJNUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:50:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:65178 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbZJNUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:50:55 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANDW1UqrR7H+/2dsb2JhbADCAZhkhC4E
X-IronPort-AV: E=Sophos;i="4.44,561,1249257600"; 
   d="scan'208";a="409409157"
From: Roland Dreier <rdreier@cisco.com>
To: ddutile@redhat.com
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com>
	<m3ljjdstbb.fsf@intrepid.localdomain> <4AD62B52.9060200@redhat.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 14 Oct 2009 13:50:17 -0700
In-Reply-To: <4AD62B52.9060200@redhat.com> (Don Dutile's message of "Wed, 14
	Oct 2009 15:49:38 -0400")
Message-ID: <adapr8p8zue.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Oct 2009 20:50:18.0967 (UTC) FILETIME=[F095AE70:01CA4D0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I think using the same nomenclature as the PCI-SIG documents is
probably the least confusing option.  Inventing our own terminology that
conflicts with the "upstream" PCI specs is just going to confuse things,
even if the Linux terminology is "better."  With that said:

>  	"66 MHz PCIX 533",	/* 0x11 */
>  	"100 MHz PCIX 533",	/* 0x12 */
>  	"133 MHz PCIX 533",	/* 0x13 */
> 	"2.5 GT/s PCI-E",	/* 0x14 */
> 	"5.0 GT/s PCI-E",	/* 0x15 */

it is the case that PCI-SIG uses "PCI-X" and "PCIe" rather than "PCIX"
and "PCI-E".  That naming would make sense to me as something to clean up.

The table of names also seems to be missing entries for PCI-X mode 1
with ECC, although I don't know if there ever was a system with a
device that actually used that mode.

 - R.
