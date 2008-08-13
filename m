Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYHMFGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYHMFGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYHMFGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:06:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbYHMFGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:06:15 -0400
Date: Tue, 12 Aug 2008 22:05:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/22] byteorder: remove the old byteorder
 implementation
Message-Id: <20080812220545.3541f1d4.akpm@linux-foundation.org>
In-Reply-To: <1218587237.30194.96.camel@brick>
References: <1218587237.30194.96.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 17:27:17 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:

>  include/linux/byteorder/Kbuild          |    3 -
>  include/linux/byteorder/big_endian.h    |  108 ---------------
>  include/linux/byteorder/generic.h       |  173 ------------------------
>  include/linux/byteorder/little_endian.h |  108 ---------------
>  include/linux/byteorder/swab.h          |  222 -------------------------------
>  include/linux/byteorder/swabb.h         |  135 -------------------

akpm2:/usr/src/25> make headers_check
  CHK     include/linux/version.h
make[1]: `scripts/unifdef' is up to date.
/usr/src/devel/scripts/Makefile.headersinst:15: /usr/src/devel/include/linux/byteorder/Kbuild: No such file or directory
make[3]: *** No rule to make target `/usr/src/devel/include/linux/byteorder/Kbuild'.  Stop.

This is just a basic i386 allmodconfig :(  The largest risk from
these patches is build breakage, and it is quite obvious that they have
not had anything like adequate build coverage testing.

