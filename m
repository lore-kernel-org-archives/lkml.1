Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYKBMOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYKBMOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 07:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYKBMO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 07:14:27 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:12346 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYKBMO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 07:14:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q3nICT433ZdYpSvrA2auVP0A42mMn1BKvhgEMsR3oDizyItx9WzYL3gbCJTCPwVBLJ
         gKJR4DXNzcRhUn/ipbNNNZoUsGOgkf9duN7m2yeyQ94wJwe1MnjTlzj0p3Y1A/BG4TVH
         E1LK/abB56uIDa8nciJugao4VmbfuVdS2R/Lw=
Message-ID: <490D999C.4070709@gmail.com>
Date: Sun, 02 Nov 2008 13:14:20 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Adam Nielsen <a.nielsen@shikadi.net>
CC: Jiri Kosina <jkosina@suse.cz>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: Driver for new hid class
References: <490C4133.30400@shikadi.net> <alpine.LRH.1.10.0811012122250.19257@twin.jikos.cz> <490CE432.5040005@shikadi.net> <490D4C0B.603@shikadi.net>
In-Reply-To: <490D4C0B.603@shikadi.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2008 07:43 AM, Adam Nielsen wrote:
> Does this mean I need to blacklist it to stop the HID input driver from
> claiming it?

Yes, add the ids also to hid_blacklist to forbid generic driver binding the device.
