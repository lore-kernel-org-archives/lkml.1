Return-Path: <linux-kernel-owner+w=401wt.eu-S1763243AbZDANbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763243AbZDANbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZDANbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:31:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:12943 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbZDANbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BPC6Jx3xUOIZPQnXkk5x3Hji+DrjAbGujk4u3RZfDFEdw9jRCtt5cm+0wCyVY7u5jf
         U/OrJMLcvdDc5RqqBTZyDsSkfhI/DEhcyHPBx52bkNGv4EHkxThPLI2HaGgcRqcQYTFR
         plxd3bG/gGu6g4/k3xoQClTsHo0Q9jTHeD6UM=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0904011245130.12751@blonde.anvils>
References: <28c262360903310338k20b8eebbncb86baac9b09e54@mail.gmail.com>
	 <Pine.LNX.4.64.0903311154570.19028@blonde.anvils>
	 <20090401165516.B1EB.A69D9226@jp.fujitsu.com>
	 <Pine.LNX.4.64.0904011245130.12751@blonde.anvils>
Date: Wed, 1 Apr 2009 22:30:58 +0900
X-Google-Sender-Auth: abddf120d38edb8f
Message-ID: <2f11576a0904010630w5ab7aaa6wccf0a9d30b43bced@mail.gmail.com>
Subject: Re: add_to_swap_cache with GFP_ATOMIC ?
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> IOW, GFP_ATOMIC on add_to_swap() was introduced accidentally. the reason
>> was old add_to_page_cache() didn't have gfp_mask parameter and we didn't
>>  have the reason of changing add_to_swap() behavior.
>> I think it don't have deeply reason and changing GFP_NOIO
>> don't cause regression.
>
> You may well be right: we'll see if you send in a patch to change it.
> But I won't be sending in that patch myself, that's all :)

OK, I'll queue it on my local patch queue. thanks.
