Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZGJQBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZGJQBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZGJQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:01:26 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41031 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZGJQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:01:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David =?iso-8859-1?q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH 0/2] Winbond driver as PNP
Date: Fri, 10 Jul 2009 10:01:21 -0600
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, "Len Brown" <lenb@kernel.org>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu> <200907091538.21685.bjorn.helgaas@hp.com> <11512ed726f2d6754f46e76c7db191a8.squirrel@www.hardeman.nu>
In-Reply-To: <11512ed726f2d6754f46e76c7db191a8.squirrel@www.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907101001.22122.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009 01:55:27 am David Härdeman wrote:
> On Thu, July 9, 2009 23:38, Bjorn Helgaas wrote:
> > Here are two sample patches to show you what I was suggesting.  These
> > apply on top of the two Winbond patches currently in -mm.
> 
> Thanks, great service :)
> 
> I'll test the patches as soon as I have time and access to the hardware.
> 
> One question though, the resulting patch series (if AKPM merges these
> patches in addition to the existing ones and drops the patch adding
> .shutdown to acpi_driver) will be git bisect unfriendly.
> 
> Should I roll two new patches instead to replace the three patches
> currently in -mm?

If you like the approach and it works, I would take the latter
approach (replace the three patches with two new ones -- e.g.,
add-pnp-shutdown-method and add-winbond-pnp-driver).  I don't
think we have to worry about bisectability until they show up
in a git tree.

Bjorn
