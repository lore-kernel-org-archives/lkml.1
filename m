Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbZHUMjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbZHUMjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZHUMjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:39:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57690 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZHUMjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YGJoHTIo2SjLUekUYzDQpn9A9bRjiYlA/6/nba6bTu8adHRjDF18leYOxdySQlUzxp
         CSBSepFruMyQo/21ZbCKg0Z4Vocaw7Hp0vRXgmSgjHByJfrQIfFsAXLOYmKv4p58zske
         GXm476ACIXdcW1lo1WaTzNJk06tC32oRPnEuE=
MIME-Version: 1.0
In-Reply-To: <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
References: <20090820015624.GE524@hash.localnet>
	 <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
	 <20090820111937.GF524@hash.localnet>
	 <19f34abd0908200502n6ff53e71ld5bc18aa581d5625@mail.gmail.com>
	 <20090821020633.GA25571@hash.localnet>
	 <19f34abd0908202346p57de93bew257b046899d7a1da@mail.gmail.com>
Date: Fri, 21 Aug 2009 15:39:08 +0300
X-Google-Sender-Auth: 15fbdda8d2a7ddd8
Message-ID: <84144f020908210539h32ef9db1lda81d1a646efecea@mail.gmail.com>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 9:46 AM, Vegard Nossum<vegard.nossum@gmail.com> wrote:
> I think that's it. Any thoughts? I put Eric Paris on Cc.

Nice catch by kmemcheck! I don't think that explains the original slab
corruption, though. Bob, you might want to try again with the fsnotify
fix applied.

                        Pekka
