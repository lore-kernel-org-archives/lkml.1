Return-Path: <linux-kernel-owner+w=401wt.eu-S1030459AbXCFJht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030459AbXCFJht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030463AbXCFJhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:37:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030459AbXCFJhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:37:47 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1173165927.17134.5.camel@roc-desktop> 
References: <1173165927.17134.5.camel@roc-desktop> 
To: bryan.wu@analog.com
Cc: roland@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] utrace: nommu fixup support utrace 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 09:37:38 +0000
Message-ID: <17048.1173173858@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Bryan <bryan.wu@analog.com> wrote:

> When adding utrace support to blackfin architecture, I found a compiling
> error in nommu related utrace stuff. Then this little patch will fix
> this for nommu arch utrace.

You really don't want to do it like this.  This prevents ELF shared libraries
from being shared at all if UTRACE is enabled.

David
