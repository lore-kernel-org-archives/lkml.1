Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYGBSlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYGBSlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYGBSlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:41:35 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:35350 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752571AbYGBSle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:41:34 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] PCI Hotplug: acpiphp: cleanup notify handler on all root bridges
Date: Wed, 2 Jul 2008 11:41:23 -0700
User-Agent: KMail/1.9.9
Cc: kristen.c.accardi@intel.com, garyhade@us.ibm.com,
       linux-pci@vger.kernel-org, linux-kernel@vger.kernel.org
References: <20080702020223.GA32046@ldl.fc.hp.com>
In-Reply-To: <20080702020223.GA32046@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021141.24600.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2008 7:02 pm Alex Chiang wrote:
> Hi Jesse, Kristen,
>
> During the development of the physical PCI slot patch series,
> Gary Hade kept on reporting strange oopses due to interactions
> between pci_slot and acpiphp.
>
> 	http://lkml.org/lkml/2007/11/28/319
>
> He got busy and went away for a while, and that's when I was able
> to sneak my patchset into Jesse's linux-next branch. ;)
>
> Recently, Gary got some time to test again on his x3950 M2
> system, and together, we finally figured out the oops.
>
> This bug has always been present in acpiphp so it's not a
> regression. So if you want to hold off until the next merge
> window, I'm ok with that.
>
> Otherwise, I feel it's pretty low-risk and could go into the next
> -rc. Totally your call, I have no strong feelings either way.

given that it fixes some pretty bad behavior, I went ahead and pushed this 
into my pull request for Linus.  Thanks for cleaning it up, the hotplug code 
is looking much better these days thanks to yours and Kenji-san's efforts.

Jesse
