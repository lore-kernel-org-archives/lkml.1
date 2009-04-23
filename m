Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZDWX2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZDWX2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZDWX2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:28:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZDWX2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:28:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: tracehook_unsafe_exec: remove the stale comment
In-Reply-To: Oleg Nesterov's message of  Thursday, 23 April 2009 23:22:50 +0200 <20090423212250.GA22537@redhat.com>
References: <20090423212250.GA22537@redhat.com>
X-Shopping-List: (1) Icelandic Food
   (2) Blasphemous warrior dandelions
   (3) Reddy-Mix Absorbers
   (4) Asymmetrical admonishers
Message-Id: <20090423232717.975ABFC3C7@magilla.sf.frob.com>
Date: Thu, 23 Apr 2009 16:27:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> tracehook_unsafe_exec() doesn't need task_lock(), remove the old comment.

Please make it instead say that cred_exec_mutex is held by the caller
through the exec.  That locking takes the place of what task_lock() was
doing before (e.g. interlock with PTRACE_ATTACH).


Thanks,
Roland
