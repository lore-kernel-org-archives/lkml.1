Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbYCDJkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbYCDJkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbYCDJkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:40:14 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:30601 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbYCDJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:40:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CJ0FtF8qsr/ZEEtiV/LeOiG9zOAUQP2KSSl1McRqE0Y/RX5jLpfeO9VUbtFligHyK8u2FvqhCmPA/n6zn3g/YbKOfAbAn55x2s1B4+lqhaR1iPdotgn56eOtGyqOW+c55Dnh2zDn593gjjdg3lfZA8wvMpys4MYx719KCaAY3s8=
Message-ID: <47CD18F5.4050705@gmail.com>
Date: Tue, 04 Mar 2008 18:40:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk>
In-Reply-To: <20080304093536.GH6704@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Looks excellent to me, has a variant of this been tested as OK by the
> users reporting the regression?

Yeah, the other version which added extra_len to data_len has been
verified to work.  The only difference is now libata is adding
extra_len, so this one should be safe.

-- 
tejun
