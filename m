Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbYJSTkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbYJSTkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 15:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYJSTkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 15:40:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:51607 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbYJSTkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 15:40:03 -0400
Date: Sun, 19 Oct 2008 21:40:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Noonan <steven@uplinklabs.net>,
       Justin Mattock <justinmattock@gmail.com>,
       Sven Anders <anders@anduras.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org
Subject: Re: several messages
In-Reply-To: <1224425749-22652-2-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LNX.1.10.0810192135010.27479@jikos.suse.cz>
References: <1224425749-22652-1-git-send-email-jirislaby@gmail.com> <1224425749-22652-2-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008, Jiri Slaby wrote:

> +enum hid_type {
> +	HID_TYPE_UNKNOWN = 0,
> +	HID_TYPE_MOUSE,
> +	HID_TYPE_KEYBOARD
> +};
> +

Do we really need the HID_TYPE_KEYBOARD at all? It's not used anywhere in 
the code. I'd propose to add it when it is actually needed. I.e. have the 
enum contain something like HID_TYPE_MOUSE HID_TYPE_OTHER for now, and add 
whatever will become necessary in the future, what do you think?


On Sun, 19 Oct 2008, Jiri Slaby wrote:

> +/**
> + * hid_mouse_ignore_list - mouse devices which must not be held by the hid layer
> + */

I think a more descriptive comment would be appropriate here. It might not 
be obvious on the first sight why this needs to be done separately from 
the generic hid_blacklist. I.e. something like

/** 
 * There are composite devices for which we want to ignore only a certain
 * interface. This is a list of devices for which only the mouse interface 
 * will be ignored.
 */

maybe?

Thanks,

-- 
Jiri Kosina
SUSE Labs
