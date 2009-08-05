Return-Path: <linux-kernel-owner+w=401wt.eu-S933711AbZHEHX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbZHEHX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933702AbZHEHX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:23:26 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46102 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbZHEHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BXWvoT1I9H3JR731pFvbfN6EGNhx8GehtG4p6I8P38vRYtxLeBVeCiINLzL+Jz3tef
         tr4ZqQBxbgwYoWCJXDKL9NwNC9NrYJH9tuGKBuAPg/f/UgPu1vmuHFM3qnizjgrfjQVs
         o8AZpLUbtBFQuC47htwIXqkZBq/CLVR6e4ZAM=
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 17:23:26 +1000
Message-ID: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com>
Subject: ftrace scripts and make V=1
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

So I spent 3-4 hrs today (I'm stupid yes) tracking down a .o breakage by
blaming rawhide gcc/binutils as I was using make V=1and seeing only the
compiler chain running,

However some ftrace script was sneaking in afterwards
and screwing up the .o without mentioning itself.

Surely V=1 should print all these shitty scripts its running?

Dave.
