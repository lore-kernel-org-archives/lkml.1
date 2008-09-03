Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYICJJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYICJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYICJJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:09:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:23860 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYICJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id:from
         :sender;
        b=uCPLKBo+qXMwpSp9nLMAlqYCA9zBfvFS6yFqWj4Z6gbfN9Nb9BWSpI1WDle0rcRqOd
         gJ6oIYilnKwqIcdbORTJ826AAodg04FkbqKui0XGQjX8v0wNAKhmJBkBy+P24/v4PKgG
         +IfQJtlSUjvU53iAfojQ/9/xwLja31ZVwwuwg=
To: linux-kernel@vger.kernel.org
Subject: [x86] fs, gs purpose & multicore prog
Date: Wed, 3 Sep 2008 11:09:45 +0200
User-Agent: KMail/1.9.9
Cc: goretux@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031109.45660.goretux@gmail.com>
From: Eric Lacombe <tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've some questions about IA-32e in Linux.

- What is the FS and GS segments role inside the kernel ?
(I was thinking about thread local storage)

- When I do a "mov %fs ..." instruction (in a module), it seems that %fs is 
equal to 0 (idem for %gs). Are these registers not always filled ?

- What is the purpose of MSR_FS_BASE and MSR_GS_BASE ? 
(I thought they were filled with "gdt[fs_entry].base")

- My last question is about the kernel programation of multi-core (or 
multiprocessor)
architecture. I don't see a lot of documentation about that on Internet.
Do you have some docs/urls about this topic.
Maybe someone can briefly explain how the execution flow are given to the 
different cores.

Thanks in advance.

        Eric
