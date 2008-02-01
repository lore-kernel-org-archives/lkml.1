Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbYBAK4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbYBAK4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYBAK42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:56:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbYBAK40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:56:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] feature-removal: Document suspend/hibernate deprecations
Date: Fri, 1 Feb 2008 11:54:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1201840628-23136-1-git-send-email-lenb@kernel.org> <1201844914.23523.84.camel@brick>
In-Reply-To: <1201844914.23523.84.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011154.01492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Harvey Harrison wrote:
> Let this appear as deprecated in 2.6.25, remove after three
> releases (2.6.28).

Thanks, I'll post a more complete version of the patch later today.

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Something like this should be included if you are deprecating
> userspace functionality.  I tried to come up with a useful
> reason from your changelogs, but you should fill this in.
> 
>  Documentation/feature-removal-schedule.txt |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 181bff0..cb005de 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -354,3 +354,28 @@ Why:	The support code for the old firmware hurts code readability/maintainabilit
>  	and slightly hurts runtime performance. Bugfixes for the old firmware
>  	are not provided by Broadcom anymore.
>  Who:	Michael Buesch <mb@bu3sch.de>
> +
> +---------------------------
> +
> +What:	SNAPSHOT_PMOPS ioctl
> +When:	2.6.28
> +Why:	Badly designed interface, obsoleted by SNAPSHOT_PLATFORM_SUPPORT and
> +	SNAPSHOT_POWER_OFF
> +Who:	Len Brown <len.brown@intel.com>
> +
> +---------------------------
> +
> +What:	SNAPSHOT_SET_SWAP_FILE ioctl
> +When:	2.6.28
> +Why:	Insert reason here
> +Who:	Len Brown <len.brown@intel.com>
> +
> +---------------------------
> +
> +What:	SNAPSHOT_ATOMIC_SNAPSHOT, SNAPSHOT_AVAIL_SWAP, SNAPSHOT_GET_SWAP_PAGE ioctls
> +When:	2.6.28
> +Why:	Defined in a non-portable manner, new numbers introduced, old numbers
> +	deprecated.
> +Who:	Len Brown <len.brown@intel.com>
> +
> +---------------------------
