Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbYBRNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbYBRNGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761448AbYBRNEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:04:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761441AbYBRNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:04:06 -0500
Date: Mon, 18 Feb 2008 05:01:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, alexn@dsv.su.se,
       dwalker@mvista.com
Subject: Re: 2.6.25-rc2-mm1: new create_proc_entry() users
Message-Id: <20080218050123.ddccf5ef.akpm@linux-foundation.org>
In-Reply-To: <20080217105050.GC6596@martell.zuzino.mipt.ru>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080217105050.GC6596@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 13:50:50 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > profile-likely-unlikely-macros
> > page-owner-tracking-leak-detector
> > cciss-procfs-updates-to-display-info-about-many-volumes
> 
> Guys, create_proc_entry() is slightly racy in case of modular code and
> proc_create() was invented to fix it. Eventually all create_proc_entry()
> users will be converted to proc_create(), so please do it for new code.

The first two patches are -mm-only debug patches - they won't be going into
mainline.

I'll make a note that
cciss-procfs-updates-to-display-info-about-many-volumes.pach needs
updating, thanks.

