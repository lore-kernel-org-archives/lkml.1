Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZABIee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZABIee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZABIdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:33:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:18317 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZABIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:33:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=cLZqnq0/EFIGJ5kkJWHUVE0kBebvDfc6TiyCtq7QjMwKiC6FJ2tI3cqrxzQvHch3cu
         q8PUhADfbKh47/pZvySb6k5ZzF48Xiru29NyzrRT/9fiQ93qyeeEvAr7+zleMYL4rJAT
         2zAWLzDDSVNEzTEnCf02MTJQuP4AodYFqSSVk=
User-Agent: quilt/0.46-1
Date: Fri, 02 Jan 2009 11:27:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Cc: gorcunov@gmail.com
Subject: [patch 0/3] trivial fixes
Message-ID: <495dd169.0437560a.1cd3.ffffd4ff@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a series of trivial patches. The only
one I'm doubting about is

	mm: hugetlb -- get rid of redundant if operation

since this form of 'if' was here pretty long time either
there is nonobvious reason for it or it just happened
to take place (well there is also a third varian which
I would prefer to not reveal -- I've missed somthing :-).

Please review

-- 
