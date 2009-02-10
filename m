Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZBJMkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZBJMkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZBJMkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:40:22 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:21718 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbZBJMkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:40:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LyFLmP1W6KofqP+kbRU1e4GHQGva5isKVLjq5IrgpSrh/X3HzBBPHyv7KtFqNnj1tJ
         b2Vmf7XZl0AaEzEjsFPYt96NMoeLrMYp4RhZem0XMX2qN9Ns/BfNe85TA289XmdZ7c9I
         MHxX/6+FUXneTnC/DNReR6pqD7GhBH6qdHR1s=
MIME-Version: 1.0
In-Reply-To: <20090210213502.7007.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210210520.7004.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360902100431l4a5977e7p9c5152882f09dcf9@mail.gmail.com>
	 <20090210213502.7007.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Tue, 10 Feb 2009 21:40:19 +0900
Message-ID: <28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com>
Subject: Re: [RFC] vmscan: initialize sc->nr_reclaimed in do_try_to_free_pages()
From: MinChan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:35 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hmm.. You're right.
>> As Johannes pointed out,
>> too many page shrinking can degrade resume performance.
>>
>> We need to bale out in shrink_all_memory.
>> Other people, thought ?
>
> shrink_all_zones() already have bale-out code ;)
>

Ahh.. I need to sleep. :(
Thanks. Kosaki-san.



-- 
Kinds regards,
MinChan Kim
