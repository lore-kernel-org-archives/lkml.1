Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbYFDMSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbYFDMSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762388AbYFDMQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:16:13 -0400
Received: from styx.suse.cz ([82.119.242.94]:35644 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761641AbYFDMQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:16:11 -0400
Date: Wed, 4 Jun 2008 14:16:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 06/10] HID: move logitech report quirks
In-Reply-To: <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
Message-ID: <Pine.LNX.4.64.0806041415130.10085@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Jiri Slaby wrote:

> Move them from core code to a separate driver.

Hi Jiri,

is there a reason why this moves only the report descriptor 
Logitech-specific quirks, but leaves the input mapping still in 
hid-input-quirks.c and doesn't move it into ->input_mapping method too?

Thanks,

-- 
Jiri Kosina
SUSE Labs
