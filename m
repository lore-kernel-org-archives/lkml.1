Return-Path: <linux-kernel-owner+w=401wt.eu-S1763226AbZC0CMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763226AbZC0CMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbZC0CMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:12:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:64148 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZC0CMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HbxJFJBZZSj8o78EKGIhVTEoyz+yx3F0w5dy2ZtFd9tITy6d6DTYtxoWRXVVpvUrGd
         BBcZmpXGek8qPvYJa7dvnpscd6dDHKdnZHy33vUaDXSH8ulXAu9ZagDfEbYlquScF26t
         4Z4+PosiqblTHLiKmJRnKwSVL7E6y6ljDgD2Y=
MIME-Version: 1.0
Date: Fri, 27 Mar 2009 11:12:21 +0900
Message-ID: <28c262360903261912n4ce235c6wf2f75b2be7faf0f4@mail.gmail.com>
Subject: Question about PRIVATE_FUTEX
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Eric Dumazet <dada1@cosmosbay.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter and Eric.

I am not expert about futex.
I am sorry if this is dumb question.

If we use private futex, get_futex_key don't call get_user_pages_fast
which pins page at page table.
Then, get_futex_value_locked calls __cpy_from_user_inatomic with
pagefault_disable.

Who make sure the user page is mapped at app's page table ?

-- 
Kinds regards,
Minchan Kim
