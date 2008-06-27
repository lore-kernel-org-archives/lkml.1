Return-Path: <linux-kernel-owner+w=401wt.eu-S1765716AbYF0Vy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765716AbYF0Vy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765322AbYF0Vsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:48:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:29958 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765305AbYF0Vs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=B2QTfW4jlzfclZCX3SsV7P1xNYX0lh1nGzIrLxeY/ws9Q7OAKevZmL04iufy5EOxAH
         rrDbQkqiyLNdd/gX1i4IJOI6vCLkPVK8kPjgkHKFZKP0DdF1+ibngVcm+Y33PSTW6zbp
         jNhELvX+Bljsu83Fcjwdxa7J69UkkmfV0TUAk=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] Fix copy_user on x86_64
Date: Fri, 27 Jun 2008 23:48:24 +0200
Message-ID: <m3k5gazh07.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've moved functionality of copy_user_64.S and copy_user_nocache_64.S to
copy_user_64.c. Tail handling is now in plain C routine.

copy_user_generic_string, copy_user_generic_unrolled and
__copy_user_nocache were tested by me with a bit modified systemtap's
script which was in attach in my previous letter.
-- 
wbr, Vitaly
