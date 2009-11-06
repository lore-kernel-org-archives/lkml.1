Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbZKFV0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbZKFV0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbZKFV0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbZKFV0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:26:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] ptrace: copy_thread() should clear TIF_SINGLESTEP and
	X86_EFLAGS_TF
In-Reply-To: Oleg Nesterov's message of  Friday, 6 November 2009 22:16:37 +0100 <20091106211637.GA1696@redhat.com>
References: <20091106211637.GA1696@redhat.com>
Emacs: an inspiring example of form following function... to Hell.
Message-Id: <20091106212554.BD731CF@magilla.sf.frob.com>
Date: Fri,  6 Nov 2009 13:25:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is also the TIF_FORCED_TF logic to check.  Probably it should just
call user_disable_single_step() instead.  Perhaps copy_process() should
just call that and then no per-arch changes would be required.


Thanks,
Roland
