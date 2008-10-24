Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYJXGZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYJXGZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYJXGZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:25:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:44764 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYJXGZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xWbJlr7nGk+dy/KZuGvl4lpZSUPUrmmCQtMXAsrXrXbQuJD+N6RCyW5s/t4Phtg1g9
         C2jQARTWbWdQo30NuxR8hGeAWGgUif8L0tGewiR3BuTlL/PDJykoI3y841j3UWQh8xj4
         nif0VFzgPdunbtXFLFrwWJQ18fOnrOxgl29VM=
Message-ID: <49016A44.8040901@gmail.com>
Date: Thu, 23 Oct 2008 23:25:08 -0700
From: Joe Damato <ice799@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: linux-x86_64@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: x86: newb question - how to build everything which deps on x86
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

I am working on cleaning up include/asm-x86/desc_defs.h specifically 
replacing the fields a,b with more descriptive fields and including some 
other cleanups for using idts. I have some changes locally but as I was 
working on this I found that I had to make some changes to 
kernel/apm32.c kernel/cpu/common.c vmi and lguest (they all used the ->a 
and ->b fields directly).

There are probably more things in the kernel that depend on x86 and 
might break with my change. Is there some config flag I can flip to 
build all x86 related things? I tried a few patterns with grep, but I 
just want to make sure I don't break anyone's stuff.

Thanks,
Joe
