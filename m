Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXCTOfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXCTOfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCTOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:35:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:17544 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbXCTOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sp4WOK0yiht207Wc+lrN6qxXD0Pjd5km7Wv5hvvjuFl5EHmEH8mVgxJ/Q+fsqJRtRkLwyKN03iClp1AiTpisXvN8snd00K2Pv3s04movCmr+wPnSFhNtCT9I0S5skDtJVJNfH4N3KjW2Z6yRsrJMqk2Zqa/BG87bC90RrM/P4y4=
Message-ID: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com>
Date: Tue, 20 Mar 2007 07:35:06 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc4-mm1 + 3 hot-fixes -- WARNING: could not find versions for .tmp_versions/built-in.mod
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like the number of section mismatches is much reduced, which
is great.  But, I don't remember seeing "WARNING: could not find
versions for ..." warnings before.  Is this an artifact of the
init/.missing_syscalls.h problem I encountered earlier?

  MODPOST vmlinux
WARNING: could not find versions for .tmp_versions/head.mod
WARNING: could not find versions for .tmp_versions/init_task.mod
WARNING: init/built-in.o - Section mismatch: reference to .init.text:
from .text between 'rest_init' (at offset 0x101) and 'try_name'
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: mm/built-in.o - Section mismatch: reference to
.init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
offset 0x15c8f) and '__section_nr'
WARNING: mm/built-in.o - Section mismatch: reference to
.init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
offset 0x15d02) and '__section_nr'
WARNING: mm/built-in.o - Section mismatch: reference to
.init.data:initkmem_list3 from .text between 'set_up_list3s' (at
offset 0x18c32) and 's_start'
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
WARNING: could not find versions for .tmp_versions/built-in.mod
