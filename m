Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYDHKn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYDHKn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYDHKnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:43:33 -0400
Received: from os.eurotux.com ([216.75.63.6]:41814 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYDHKn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:43:26 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2008 06:43:25 EDT
To: linux-kernel@vger.kernel.org
Subject: proc_stack for x86_64 (spinning process)
Content-Disposition: inline
From: Nuno Pais Fernandes <npf@eurotux.com>
Organization: Eurotux Informatica S.A.
Date: Tue, 8 Apr 2008 11:36:41 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804081136.41876.npf@eurotux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a spinning process that it's locking my server (eating 100% CPU). I 
can't kill it even with kill -9

I'm trying to use proc_stack to check what's the problem, compiling the kernel 
with

http://linuxhacker.ru/~nikita/patches/2.6.12-rc6/2005.06.11/vm_07-proc-stack.patch

But this patch is only for x86 as my arch is x86_64. Does anyone know if 
there's a patch for x86_64?

Thanks
Nuno Fernandes
