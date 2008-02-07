Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYBGQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYBGQ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYBGQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:57:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42830 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYBGQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:57:40 -0500
Date: Thu, 7 Feb 2008 08:57:21 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: lkml <linux-kernel@vger.kernel.org>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net
Subject: Re: [PATCH][RFC] x86: oprofile 32bit stack traces on 64bit kernel
Message-ID: <20080207085721.4a4e36ee@laptopd505.fenrus.org>
In-Reply-To: <47A88CE4.3070205@windriver.com>
References: <47A88CE4.3070205@windriver.com>
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

On Tue, 05 Feb 2008 10:20:52 -0600
Jason Wessel <jason.wessel@windriver.com> wrote:

> 
> There are multiple ways to write the same code, hence the reason this
> is listed as an RFC patch.  I wanted to provide a working fix to
> account for the case of executing 32 bit and 64 bit user space code on
> a 64 bit kernel.
> 
> -----CLIP HERE-------
> 
> Allow oprofile's backtrace to work on a 32bit user space thread when
> running on a 64bit kernel.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>



looks sane; it'll be better than what is there now at least
and it's safe enough

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
