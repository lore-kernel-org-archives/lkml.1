Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbXISSgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbXISSgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXISSf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:35:56 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57812 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbXISSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:35:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18161.27621.630048.643513@alkaid.it.uu.se>
Date: Wed, 19 Sep 2007 20:35:17 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, james-p@moving-picture.com,
       linux-kernel@vger.kernel.org, aarapov@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
In-Reply-To: <46F1475B.5050107@zytor.com>
References: <200709191454.l8JEsAQO010080@harpo.it.uu.se>
	<46F1475B.5050107@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > Mikael Pettersson wrote:
 > > On Wed, 19 Sep 2007 14:35:29 +0100, James Pearson wrote:
 > >> /proc/PID/environ currently truncates at 4096 characters, patch based on 
 > >> the /proc/PID/mem code.
 > > 
 > > Does /proc/PID/mem even work? If I do `strace cat /proc/PID/mem > /dev/null'
 > > for a known good PID, the first read() from /proc/PID/mem fails with ESRCH,
 > 
 > Of course it does.  Address zero isn't typically mapped.

Indeed. My bad :-(
