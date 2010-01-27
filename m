Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577Ab0A0LaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0A0LaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170Ab0A0LaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:30:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:49627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0A0LaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=A8J/DJwIOUWJ9iDN03kPJt+7pZV9kOfggIusgBRTVFnxYhltIeSWOaUJUMnsSMkp7v
         si5plojHTkL7jy9H8YTMDnTrDaJLhHToAp510kJJfs5tbzUWwVhZoZkibFm/Kc9Ms/vk
         ACuXHtSvUFT7h/DUJGNbs2C56/hUODHEryXno=
Message-ID: <4B6023B6.7090006@gmail.com>
Date: Wed, 27 Jan 2010 12:29:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jiri Slaby <jslaby@suse.cz>, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PM: remove deprecated user ioctls
References: <1264589875-17045-1-git-send-email-jslaby@suse.cz> <20100127112215.GA11551@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100127112215.GA11551@atrey.karlin.mff.cuni.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 12:22 PM, Pavel Machek wrote:
>> They were deprecated and removed from exported headers more than 2
>> years ago.
> 
> Should not this go through feature removal schedule etc...? Add
> printks when someone uses deprecated ioctl?

Yeah, likely. I though about that it was moved out of exported headers,
but I realized just now that already compiled binaries are not affected
and users won't spot (only packagers do).

thanks,
-- 
js
