Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569Ab0AHPE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0AHPE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547Ab0AHPE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:04:58 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44077 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0AHPE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZO/bsyreQUZwYmhIzjYs8PQ/5X08p8GwItWdckI9Wo+vDLiCRB+1ZN55hWxaT88Ir4
         HF1X3r6cNo1PI1dlobTTj2i32qKChS/VEg3KTWWvEYp/wIxzpDz0sFJsEyDvwoZehrx2
         lS7F9sTEjM2buLpe3KSFCe4fgsEK8qtZSeUQM=
Subject: RFC: [PATCH V2 0/9 Integration of SmartMedia/xD into mtd subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:04:52 +0200
Message-ID: <1262963092.12577.14.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is second version of my patchset.

Changes since V1:

-> Ported to latest kernel revision (2.6.33-rc3)
-> Resolved problem with oob layout
-> Resoved all checkpatch.pl issues
-> Tested that indeed all hardware devices of this type have
same PCI ID


Remaining issues:

* Write speed is of course still very low, but like I said, it might be
hardware problem.

* No support for 256 byte SmartMedia in the FTL. I don't have the
hardware to test that, and I think for now there is not much need for
that.
(It only applies to 1MB and 2MB SmartMedia devices anyway...)

* Like I said some XD cards are fake, thus have to be used with the FTL,
This is a hardware problem too.
If I knew which xD cards are affected, and had a way to know for sure
they have an FTL inside, I could implement a fake FTL, thus gain higher
write speed (and maybe solve that way issue #1)


Best regards,
Maxim Levitsky


