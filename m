Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbXKTRxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbXKTRxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXKTRxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:53:13 -0500
Received: from saeurebad.de ([85.214.36.134]:56304 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313AbXKTRxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:53:11 -0500
Date: Tue, 20 Nov 2007 18:53:03 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Daniel Reichelt <mail@itamservices.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Patch: Hide process info from other users/users not in my group
Message-ID: <20071120175303.GA19475@cataract>
Mail-Followup-To: Daniel Reichelt <mail@itamservices.de>,
	linux-kernel@vger.kernel.org
References: <4742B82C.3060001@itamservices.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4742B82C.3060001@itamservices.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Nov 20, 2007 at 11:34:20AM +0100, Daniel Reichelt wrote:
> # diff -Naur linux-2.6.23.8/fs/Kconfig linux-2.6.23.8-dhr/fs/Kconfig
> --- linux-2.6.23.8/fs/Kconfig   2007-11-16 19:14:27.000000000 +0100
> +++ linux-2.6.23.8-dhr/fs/Kconfig       2007-11-20 11:33:18.000000000 +0100
> @@ -918,6 +918,17 @@
>          help
>          Exports the dump image of crashed kernel in ELF format.
> 
> +config PROC_SECURED_PID_DIRS
> +       bool "chmod /proc/<pid>-dirs to 550"
> +       depends on PROC_FS
> +       default n
> +       help
> +         chmod /proc/<pid>-dirs to 550 instead of 555 which provides a bit
> +         moreprivacy to users on your system as only the user's and the user's

Missing space   ^.

I like the idea, but I would prefer to have three checkboxes for this option:

	* Normal modes (as in how they are right now)
	* User and group visible
	* Visible for the owning user only

How about that?

	Hannes
