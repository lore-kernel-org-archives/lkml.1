Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbZJFWVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbZJFWVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbZJFWVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:21:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43983 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933799AbZJFWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:21:35 -0400
Date: Tue, 6 Oct 2009 23:22:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, greg@kroah.com,
       charles.f.johnson@intel.com, Mark Allyn <mark.a.allyn@intel.com>
Subject: Re: [PATCH] Changes to integrate RAR with SEP and fix RAR problems
Message-ID: <20091006232217.18e3f0f4@lxorguk.ukuu.org.uk>
In-Reply-To: <1254861953-18099-1-git-send-email-mark.a.allyn@intel.com>
References: <1254861953-18099-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -121,7 +121,7 @@ source "drivers/staging/hv/Kconfig"
>  
>  source "drivers/staging/vme/Kconfig"
>  
> -source "drivers/staging/rar/Kconfig"
> +source "drivers/staging/rar_register/Kconfig"

Its impossible to compare changes in diffs if you move them around and
then diff them. Please don't do that. Produce the diffs using the same
directory - it can move anyway when the thing comes out of staging

If you must move something then do the move and the changes as two
separate patches so it is clear. You do seem to have also done things
like reformatted the code, or worked off an old tree not the kernel one
for the changes which isn't helpful.
