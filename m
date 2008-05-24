Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbYEXBXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbYEXBXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYEXBXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:23:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbYEXBXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:23:08 -0400
Date: Fri, 23 May 2008 18:23:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linu-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add switch for dock events
Message-Id: <20080523182300.bd05ec54.akpm@linux-foundation.org>
In-Reply-To: <20080523160955.GA19674@srcf.ucam.org>
References: <20080523160955.GA19674@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 17:09:55 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Add a switch to signal dock events to userspace.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> I've done this as an input event rather than anything else since there 
> isn't necessarily a terribly coherent concept of a dock device. HPs (for 
> example) don't use ACPI for docking - the dock is simply an extension of 
> devices that are already on the system. We can't sensibly create a dock 
> platform device and then generate uevents on it. Doing it this way lets 
> us standardise on a way to send docking events to userspace, which lets 
> desktops do things like automatically expand onto external monitors when 
> the system is docked.
> 
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 28a094f..0bc55ee 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -638,6 +638,7 @@ struct input_absinfo {
>  #define SW_TABLET_MODE		0x01  /* set = tablet mode */
>  #define SW_HEADPHONE_INSERT	0x02  /* set = inserted */
>  #define SW_RADIO		0x03  /* set = radio enabled */
> +#define SW_DOCK			0x04  /* set = plugged into dock */
>  #define SW_MAX			0x0f
>  #define SW_CNT			(SW_MAX+1)
> 
> 

Confused.  This patch doesn't do anything.

Also, please sort out the changelogging?

- The one-line changelog you have there would make a decent _title_. 
  Better than the one which was actually chosen.

- The not-to-be-included discussion which you have below the "---"
  cutoff line would make a reasonable changelog.

