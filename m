Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbZCOKGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbZCOKGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCOKGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:06:42 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:35968 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZCOKGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=EOuFMoJ4X0wqU9a2Pj9aV1Ud6QFjA1NqTbiwIW1ZN+pzCmOayId3rzG4mR2RAUG+k8
         cLxEzTEPR2SAH+AGerEgxwFK2C2BdbeWDELiaqmmpiPgmyfcrQxQm9ljuc3R4auBhjE+
         f6548RSAIMSSfwdDzraj7DWwqVfojOfX5E8Hs=
Message-ID: <49BCD2F6.6030903@panasas.com>
Date: Sun, 15 Mar 2009 12:05:42 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rcx triviality - How to have foo.ko module with same name
 as foo.c source file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sometime in the 2.6.29-rc I'm no longer able to produce an
out-of-tree module that has the same base-name as a source file.

This is what I had in 2.6.28:
<Kbuild>
    obj-m += foo.o
</Kbuild>
Where foo.c is a source file in the same directory.

But since 2.6.29-rcx it will no longer build my foo.ko module. I
had to change it to:
<Kbuild>
    foo_mod-y = foo.o
    obj-m += foo_mod.o
</Kbuild>
Which changed my module name in scripts and packages.

[Q]
  Is it possible to build a module with exact same base-name as it's single
  source file?

P.S:
  Just asking I realized that I can just add an "mv ..." command to my make file.
  But is this expected behaviour?

Thanks in advance
Boaz
