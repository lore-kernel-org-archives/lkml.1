Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYFRJkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYFRJkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYFRJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:40:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:43266 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396AbYFRJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:40:32 -0400
Date: Wed, 18 Jun 2008 11:40:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Philippe Troin <phil@fifi.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <871w2xnehf.fsf@old-tantale.fifi.org>
Message-ID: <Pine.LNX.4.64.0806181139490.10085@jikos.suse.cz>
References: <871w2xnehf.fsf@old-tantale.fifi.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Philippe Troin wrote:

> However this patch does not seem to work at all:
>  * the Power button keeps repeating the power key once pressed
> 
>  * the home (windows MCE green button) and the four keys below it
>    (shortcuts to movies, music, photos, tv) do not work.
> 
> Is there anything I can help with to get a working patch?

Please compile your kernel with 'CONFIG_HID_DEBUG', modprobe the 'hid' 
module with 'debug=2' parameter, and send me the output that appears is 
dmesg output when you press the non-working keys.

Thanks,

-- 
Jiri Kosina
SUSE Labs
