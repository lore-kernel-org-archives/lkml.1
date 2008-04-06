Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYDFFSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYDFFSr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 01:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYDFFSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 01:18:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbYDFFSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 01:18:37 -0400
Date: Sat, 5 Apr 2008 22:18:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: apw@shadowen.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-Id: <20080405221822.376f0018.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008 06:54:54 +0200 (CEST) Jan Engelhardt <jengelh@computergmbh.de> wrote:

>      We all had the arguments about 80 columns, so here goes a relax.
>      Checking for 95 (or perhaps something better?), but of course we
>      print "80" in the output, because if you happened to get to 95, it's
>      "really time" to break it.

This will reduce the usefulness of checkpatch for those developers who
choose to observe an 80-column limit.

>      This also relaxes the tab doctrine, because spaces DO make sense --
>      especially when you view the code with a tab setting of not-8.

Non-tab-using code inevitably ends up having a mix of tabs and non-tabs
and looks a mess if tabstops are set to anything other than eight.

God I wish I had not been cc'ed on this.
