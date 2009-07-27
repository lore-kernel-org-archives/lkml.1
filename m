Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbZG0LbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbZG0LbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZG0LbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:31:13 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:35027 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZG0LbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vUBoqje0cUg1ED+qSG2jMuTYCTJWL6h666tSWk/vQE4HU2O91ZgmccCfyihpwFf9En
         4RYyIh3Z8Q3nNxjpBzTsyPMoSS0tevvQgYSmwYGLfeDSRx3JPReTIfNzuzVulkunag9O
         vwTv5bcUUcm6sxf6KXzKtOuqGrR0OG8MlFt+0=
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 16:31:13 +0500
Message-ID: <d6bd61d30907270431k6ce7b470le8804aa54aab3fbb@mail.gmail.com>
Subject: Traversing Page Table of a process
From: "M. Shuaib Khan" <aries.shuaib@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has seriously started to give me a head ache. So an SOS for help.

I get the pgd for each process out of its mm_struct. How do I use this
pgd to get the physical addresses of all the pages. I am not writing a
code that will be part of the running kernel so none of the kernel
macros are available for my use. I am getting everything manually out
of a RAM image taken using dd.

So once I've the pgd value out of mm_struct, how do I get to the
corresponding pmd and pte addresses and eventually the physical
addresses of the pages...?

Any help/pointers greatly appreciated. Thanks.

-- 
M. Shuaib Khan
