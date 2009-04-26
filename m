Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZDZKiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZDZKiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbZDZKho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:37:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55733 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbZDZKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mu+vRQ1fJmiRGX7nCkSdcy30pwIi+O64Cq8Rp21oLlQeeqPOkY6ys6Xl/Ww1CYH/LF
         ksBLZkJSVhdUB676+r86QWOL+no5gSyH3qI1I/KUwQrtx9mwg7ecEBWL6woxN6IWCImN
         Ubco/NT7Rn4RQZyp/Ni9pxrLjZtY6kg4fi6ho=
Message-ID: <49F43975.2060106@gmail.com>
Date: Sun, 26 Apr 2009 12:37:41 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.5 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
References: <1240661363-16631-1-git-send-email-jirislaby@gmail.com> <20090426020047.GA10885@hash.localnet>
In-Reply-To: <20090426020047.GA10885@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2009 04:00 AM, Bob Copeland wrote:
> On Sat, Apr 25, 2009 at 02:09:23PM +0200, Jiri Slaby wrote:
>> Hi guys,
>> do you remember some 5211 HW which didn't work with this?
>> --
>>
>> Set null key type even on ar5211, otherwise it en/decrypts every frame with
>> protected bit set which renders the card unusable on encrypted networks.
> 
> Not me.  I don't have the hardware, so I would say if your patch is known
> to work on a 5211 then we go with it.

Ok, thanks. Of course the HW I used (IBM T40 Thinkpad) needs the patch ;).
