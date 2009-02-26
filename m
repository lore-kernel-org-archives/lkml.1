Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbZBZXdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbZBZXdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZBZXdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:33:01 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64149 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZBZXdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:33:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xrxcJpzG71o6Eqyc4S5MUD1ESZT3+3yze5nM6RVGcXvMG75ut/Z6txM2mQZ6gMZmuD
         5W0QI+3MPDal0OVAfLYtp3IsGNdROjucQoxF9rfMPKVYNHTVORhj5PYmx3EI91XBdzqP
         vGx+3Id77VdrbtCweITEZl62HNzRwX/YZuyPI=
Message-ID: <49A726A7.6090809@gmail.com>
Date: Fri, 27 Feb 2009 00:32:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
In-Reply-To: <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.2.2009 00:28, Bob Copeland wrote:
> hw_to_driver_rix() returns sc->rate_idx[x][y] as an int, and that
> array is initialized to (u8)-1 for invalid rates.  So, it can
> return 255 if the hardware rate index (y) is bad, then the check
> "rxs.rate_idx>= 0" would always be true, right?  If it's not a
> real bug yet, it likely will be one day :)

Ah, yes, it really is a bug(tm), care to post a fix?
