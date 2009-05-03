Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZECUZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZECUZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZECUZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:25:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58146 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZECUZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:25:24 -0400
Date: Sun, 3 May 2009 22:21:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090503202100.GC18889@redhat.com>
References: <20090428223025.GA11997@redhat.com> <20090501000222.8BACEFC3BF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501000222.8BACEFC3BF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Roland McGrath wrote:
>
> This is related to the issue of racing stop signals lost by de_thread().
> That is still on our back-burner list to think about more deeply one day.

Hmm. did you mean "lost by selinux_bprm_committed_creds()" ? Or do we really
have some problems with SIGSTOP && de_thread() ?

Oleg.

