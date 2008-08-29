Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYH2VOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYH2VOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYH2VN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:13:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137AbYH2VN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:13:57 -0400
Date: Fri, 29 Aug 2008 14:12:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: philipl@overt.org
Cc: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
       toshiba_acpi@memebeam.org, ivdoorn@gmail.com,
       linux-wireless@vger.kernel.org, hmh@hmh.eng.br
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling 
 through rfkill (v7)
Message-Id: <20080829141216.f0d69ae4.akpm@linux-foundation.org>
In-Reply-To: <47479.65.113.40.1.1219443825.squirrel@overt.org>
References: <47479.65.113.40.1.1219443825.squirrel@overt.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 18:23:45 -0400 (EDT)
philipl@overt.org wrote:

> There's been a patch floating around for toshiba_acpi that exports an ad-hoc
> /proc interface to toggle the bluetooth adapter in a large number of Toshiba
> laptops. I'm not sure if it's still relevant for the latest models, but it is
> still required for older models such as my Tecra M3.
> 
> This change pulls in the low level Toshiba-specific code from the old patch and
> sets up an rfkill device and a polled input device to track the state of the
> hardware kill-switch.

ERROR: "rfkill_force_state" [drivers/acpi/toshiba_acpi.ko] undefined!
ERROR: "rfkill_free" [drivers/acpi/toshiba_acpi.ko] undefined!
ERROR: "rfkill_register" [drivers/acpi/toshiba_acpi.ko] undefined!
ERROR: "rfkill_allocate" [drivers/acpi/toshiba_acpi.ko] undefined!
ERROR: "rfkill_unregister" [drivers/acpi/toshiba_acpi.ko] undefined!

I'll stick a `select RFKILL' in there, but it'll probably blow up
in other ways.  select usually does.
