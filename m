Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZDRPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZDRPER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZDRPEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:04:01 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:55107 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbZDRPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=A4ZWZzImcTTpDcHwjM372XRR/W9qtzTe5RCeX1idLhNGhx+caZYB20gIf9NjgtiB4J
         iBwfAgSqH6GeUDtrDmU6eM8o4NL3e+KulwiRYkqk+MB4YUVQIEFTj8EwEVzna9HAkw5C
         B0k1119uvemA6RQX2+uTigLcf8V4e5OdBCm4g=
Date: Sat, 18 Apr 2009 18:03:34 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: smatch-discuss@lists.sf.net, linux-kernel@vger.kernel.org
Subject: smatch 1.52 released
Message-ID: <alpine.DEB.2.00.0904181715400.5780@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a static analysis tool.

It's looks for different bugs than sparse.  It's uses sparse as a C 
parser.  It probably can find more complicated bugs than Coccinelle but it 
doesn't fix them.

The repo is:  http://repo.or.cz/w/smatch.git/

I am going to be cycling in southern Africa for the next four months.  I 
will take an eee but will only have irregular internet access.

There have been many changes since 1.51:
  * There are no known crashing bugs.
  * It uses less memory.
  * It is faster.
  * Many of the checks have been improved.
  * It uses a more sophisticated system to represent possible variable 
    values internally.
  * There is a new dereferencing ERR_PTR() check.

One thing that's fairly cool is that Smatch v1.52 understands the 
following code.

    foo = down_trylock(&lock);
    if (foo < 0)            <- implies the lock was not aquired.
            return;
                            <- lock is held here.

Anyway, do email me if you have any questions or issues.  I will probably 
have internet access some days later on next week.

regards,
dan carpenter

http://bikesafari.net


