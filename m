Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbYJINW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbYJINW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbYJINWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:22:21 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:3192 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbYJINWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:22:20 -0400
X-IronPort-AV: E=Sophos;i="4.33,383,1220227200"; 
   d="scan'208";a="22101673"
Date: Thu, 9 Oct 2008 14:21:47 +0100
From: Derek Fawcus <dfawcus@cisco.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 43/76] tty: Redo current tty locking
Message-ID: <20081009132147.GB6806@cisco.com>
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005161532.1997.19318.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005161532.1997.19318.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Authentication-Results: ams-dkim-1; header.From=dfawcus@cisco.com; dkim=pass (
	sig from cisco.com/amsdkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 05:15:37PM +0100, Alan Cox wrote:
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index c30ed8d..e00393a 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -361,6 +361,7 @@ extern int is_ignored(int sig);
>  extern int tty_signal(int sig, struct tty_struct *tty);
>  extern void tty_hangup(struct tty_struct *tty);
>  extern void tty_vhangup(struct tty_struct *tty);
> +extern void tty_vhangup_self(void);
>  extern void tty_unhangup(struct file *filp);
>  extern int tty_hung_up_p(struct file *filp);
>  extern void do_SAK(struct tty_struct *tty);

>From a pedantic pov shouldn't the above be part of patch 42 - where you
actually created tty_vhangup_self()?

DF
