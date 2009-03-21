Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZCUUfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZCUUfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 16:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZCUUfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 16:35:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbZCUUfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 16:35:11 -0400
Subject: Warning: File `include/config/auto.conf' has modification time
 1.9e+04 s in the future
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 02:04:36 +0530
Message-Id: <1237667676.17548.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam, Ingo:

On latest -tip I am getting following warnings:

  LD      arch/x86/pci/built-in.o
make[1]: warning:  Clock skew detected.  Your build may be incomplete.
make[1]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
  CC      arch/x86/power/cpu_64.o
  LD      arch/x86/power/built-in.o
make[1]: warning:  Clock skew detected.  Your build may be incomplete.
make[1]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
  CC      net/socket.o
make[2]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
make[2]: warning:  Clock skew detected.  Your build may be incomplete.
make[2]: Warning: File `include/config/auto.conf' has modification time 1.9e+04 s in the future
  CC      net/core/sock.o

[jaswinder@hpdv5 linux-2.6-tip]$ ls -l include/config/auto.conf
-rw-rw-r-- 1 jaswinder jaswinder 18788 2009-03-22 07:14 include/config/auto.conf

[jaswinder@hpdv5 linux-2.6-tip]$ date
Sun Mar 22 02:02:44 IST 2009
[jaswinder@hpdv5 linux-2.6-tip]$ 

Thanks,
--
JSR

