Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZKTU0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZKTU0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZKTU0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:26:42 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60816 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbZKTU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:26:40 -0500
Date: Fri, 20 Nov 2009 14:26:16 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Steve Grubb <sgrubb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Kees Cook <kees.cook@canonical.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [RFC] remove CONFIG_SECURITY_FILE_CAPABILITIES compile option
Message-ID: <20091120202616.GA17091@us.ibm.com>
References: <20091120201933.GA16694@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120201933.GA16694@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> @@ -457,10 +429,8 @@ static inline int get_file_caps(struct linux_binprm *bprm, bool *effective)
>   */
>  static inline int cap_limit_ptraced_target(void)
>  {
> -#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
>  	if (capable(CAP_SETPCAP))
>  		return 0;
> -#endif

Gah.  Will fix, of course, but general question/rfc still stands.

-serge
