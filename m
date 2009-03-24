Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZCXXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZCXXVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZCXXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:21:38 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48911 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZCXXVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=I48hzu9nHfRli9hBf4dlfXtc7IUvnzMDJ1GtzZGGjUZf+k1oUs7Kc0aqrEJ/3X6nWU
         BeDnbTK079dsSI6PZbQWfgyxNxUUKuUEx26fhJHH3DmRii/RrIUXaY2WNbPdlnbB4jr8
         /ta0peejtg/nKqvhY36o9ilrJGMHjByXacBis=
Message-ID: <49C96AFC.2030508@googlemail.com>
Date: Wed, 25 Mar 2009 00:21:32 +0100
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Where did struct user_regs_struct{,32} go?
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that 2.6.29 (and maybe also 2.6.28) doesn't export the
structures any longer (they used to reside in <asm/user_{32,64}.h>).
<linux/user.h> is gone as well. There is only <sys/user.h>, but it
doesn't define struct user_regs_struct32. Am I supposed to roll my own
when I want to ptrace(PTRACE_GETREGS) the registers of a 32-bit process
from 64-bit land?

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
