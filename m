Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbZD3XCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbZD3XCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZD3XCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:02:32 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:59829 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZD3XCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:02:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: What's in hid.git for 2.6.30
Date: Fri, 1 May 2009 01:02:34 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.0903251742520.14346@wotan.suse.de> <3d8471ca0904301529s140339c5w4b39e83b31d4e9c0@mail.gmail.com> <alpine.LNX.2.00.0905010044450.5012@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0905010044450.5012@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905010102.34272.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 1. Mai 2009 00:45:51 schrieb Jiri Kosina:
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1824,6 +1824,9 @@ int hid_check_keys_pressed(struct hid_device *hid)
>         struct hid_input *hidinput;
>         int i;
>  
> +       if (!(hid->claimed & HID_CLAIMED_INPUT))
> +               return 0;
> +

Jiri,

is there a guarantee all keyboards will be claimed as input devices?

	Regards
		Oliver

