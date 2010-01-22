Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676Ab0AVVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0AVVqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572Ab0AVVqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:46:46 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56038 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab0AVVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dZYgEHNkS8UoNpS/+uvSJ9722KYnZw0G1ZNe17zvP2ZznfY5V5aTU+gcQtjzlh68EJ
         UFHG/kxlrsfNj0qeuQu2YYck492QLiVkaN5QfREWcoqIH1hfZ7h0oeKRrMBaqj8xM2B3
         LrGmbv+Os2TUAZcU4+2L6UfkddnfkZPyv2YQ0=
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 13:46:45 -0800
Message-ID: <619ad6271001221346j19c9038bx8013e5b560d0c138@mail.gmail.com>
Subject: sys_rt_sigreturn calling sys_futex?
From: Ivan Novick <novickivan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a userspace app that I profiled using SystemTap.

It says there are frequent calls to sys_futex which come from sys_rt_sigreturn.

It is true, that my app has many signal handler calls due to
frequently set timers in the code.

I had a look at the source for my kernel: Suse: linux-2.6.27.39-0.3
but I don't see any calls to futex from inside sys_rt_sigreturn.

Do you know if sys_rt_sigreturn is somehow calling sys_futex?

And if so, does this imply that ultra-frequent signal handling can
create a bottleneck between many processes in the sys_rt_sigreturn
system call trying to access a futex?

Thank you and regards,
Ivan Novick
