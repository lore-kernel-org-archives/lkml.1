Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYD2WgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYD2WgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYD2Wfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:35:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45837
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbYD2Wfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:35:54 -0400
Date: Tue, 29 Apr 2008 15:35:53 -0700 (PDT)
Message-Id: <20080429.153553.197741534.davem@davemloft.net>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kgdb with sw single-step...
From: David Miller <davem@davemloft.net>
In-Reply-To: <48173852.8080107@windriver.com>
References: <20080429.010221.268320653.davem@davemloft.net>
	<48173852.8080107@windriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>
Date: Tue, 29 Apr 2008 10:01:38 -0500

> I don't think you have to actually change gdb, because for sparc64 gdb
> is set to "set_gdbarch_software_single_step (gdbarch, NULL);" This
> means it is always going to ask the stub to perform the single
> stepping.

You're reading the wrong code.

The generic sparc stuff in sparc-tdep.c sets it to
sparc_software_single_step.

Only the Solaris specific sparc target code in sparc-sol2-tdep.c
overrides this setting to NULL.
