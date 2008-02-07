Return-Path: <linux-kernel-owner+w=401wt.eu-S934426AbYBGXYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934426AbYBGXYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbYBGXYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:24:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58252 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046AbYBGXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:24:38 -0500
Date: Thu, 7 Feb 2008 15:23:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-ID: <20080207152344.7f58f44b@laptopd505.fenrus.org>
In-Reply-To: <47AB8F63.4020002@redhat.com>
References: <47AA3126.8090102@redhat.com>
	<20080206143457.03e8741d.akpm@linux-foundation.org>
	<47AA3EAA.9080204@redhat.com>
	<20080206152239.a2352d6d.akpm@linux-foundation.org>
	<47AB8F63.4020002@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 17:08:19 -0600
Eric Sandeen <sandeen@redhat.com> wrote:
> 
> ?
> 
> I couldn't think of a great name for it.  There are several noinline
> users throughout the kernel with stackspace related comments, so if
> desired, I could sprinkle this around.  I'm not very pleased with it
> aesthetically though. :)


how about just __stackhog ?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
