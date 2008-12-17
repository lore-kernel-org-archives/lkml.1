Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752142AbYLQTN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbYLQTN2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYLQTNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:13:18 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:40544 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLQTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=oCtggv2dhRdvkwTJIVbz+OJM/4c2gW0LVqk0nO4L7eRBVkL4+bTfgiOvl9Q+EOFx2k
         CMZbz6ChAZhyg4Y+0EN+bAM1gUwMH/MbcdltuiDdHl+8SbXbvPMJlB2vJxeabLqCuw3N
         UIfhirbo9QWDpEiAxiBvTaHtP9OB/Dmc29Jws=
Message-ID: <b4198de60812171113r72d8d04ao67cde38c62185bcc@mail.gmail.com>
Date: Wed, 17 Dec 2008 14:13:15 -0500
From: "Matt Turner" <mattst88@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: questions about native alpha futex implementation
Cc: "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>, rth@twiddle.net,
        "Jay Estabrook" <jay.estabrook@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alpha uses a generic futex implementation, which causes some problems [1].

I've read through the code, and it appears as if the implementation
could be done by using the ldq_l/stq_c instructions, relatively easy I
might add. I'm definitely interested in implementing this, but first...

I have only a few questions.

1) What are the benefits of a native futex implementation, other than
fixing the glibc test failures?
2) Is there a technical reason it hasn't been implemented on Alpha?
3) Am in correct that it could be done with ldq_l/stq_c instructions?

I'm not experienced with kernel development, but I'd like to learn, so
please bear with me.

Thanks,

Matt Turner

[1] http://bugs.gentoo.org/show_bug.cgi?id=205099
