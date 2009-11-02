Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbZKBDNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbZKBDNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 22:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZKBDNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 22:13:48 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54708 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZKBDNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 22:13:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=s1AE+dkwrEgQA+fosNxg2iUdJLvkOMJY69oAlAtQxkU7XeuiPpL5y6ITs6FuOS3OEb
         Sx8Taj2A6IMKc7TSnt6Q/LbqP/aHTq6eZ2zESPcxYFx6/p6752nL4rRkTzROI31WoCsd
         IlHPEIfYlkBNKQtQVjetE/xu53UUMR4O92+MM=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 11:13:51 +0800
Message-ID: <3a665c760911011913q268b010cqb5da4f79df995b9b@mail.gmail.com>
Subject: why kernel implement "udelay" by cpu instructions?
From: loody <miloody@gmail.com>
To: linux-kernel@vger.kernel.org, Kernel Newbies <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all:
I find the kernel use cpu instruction to implement the udelay function
as keeping decrease a big counter by 1.

If I search the right place in kernel, why kernel does so?
the precision will be different if cpu runs faster or slower, right?
appreciate your help,
miloody
