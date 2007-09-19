Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXISOyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXISOyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbXISOyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:54:33 -0400
Received: from aun.it.uu.se ([130.238.12.36]:55646 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbXISOyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:54:32 -0400
Date: Wed, 19 Sep 2007 16:54:10 +0200 (MEST)
Message-Id: <200709191454.l8JEsAQO010080@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: james-p@moving-picture.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
Cc: aarapov@redhat.com, akpm@linux-foundation.org, hpa@zytor.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 14:35:29 +0100, James Pearson wrote:
> /proc/PID/environ currently truncates at 4096 characters, patch based on 
> the /proc/PID/mem code.

Does /proc/PID/mem even work? If I do `strace cat /proc/PID/mem > /dev/null'
for a known good PID, the first read() from /proc/PID/mem fails with ESRCH,
which is bullocks. cat /proc/PID/environ does work. I'm seeing this on
2.6.22 vanilla, 2.6.20 FC6, and 2.6.18 RHEL5 kernels.

/Mikael
