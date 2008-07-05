Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYGEPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYGEPDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYGEPDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:03:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:13724 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGEPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=gne7cTDgXsJJhK2IOYhW3NO+jIwKLmj0Xq7gknrchcOHUXhzbkG/dfJf57CRmBRiz4
         Ar1Q6J/mDy1wWw8hfBkXs+BWX0vPkRIvR5r6AkEwCuANLPx/26x/3P/24p2DjzM96qV8
         BqhyiauNErbHGA/jJAdEWLzhKToaruqiJCCMk=
Message-ID: <486F8D55.2060506@gmail.com>
Date: Sat, 05 Jul 2008 11:03:49 -0400
From: Bradley Hanna <brahan.ml@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Creating syscalls: Under an x86_64 arch, where is the syscall table
 located?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to create a syscall for testing purposes.  I have a kernel
configured for x86_64 arch and need to know where the syscall table is
located.  I believe I have found the unistd.h file that I need under
'include/asm/unistd_64.h' but I cannot find a file containing the
'sys_call_table' that corresponds with that 'unistd_64.h' file.  I can
find a file called syscall_table_32.S, but no table for 64.  The table
is no longer located in entry.S, so where do I find it?  The
'__syscallN' macro is not finding my syscall definition.

Is that enough information?

thanks for your patience,

brahan
