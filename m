Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbXLBB2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbXLBB2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 20:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXLBB2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 20:28:34 -0500
Received: from mail2.asahi-net.or.jp ([202.224.39.198]:12239 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbXLBB2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 20:28:33 -0500
Message-ID: <47520A45.7000800@kaigai.gr.jp>
Date: Sun, 02 Dec 2007 10:28:37 +0900
From: KaiGai Kohei <kaigai@kaigai.gr.jp>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: serge@hallyn.com
CC: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] capabilities: introduce per-process capability	bounding
 set (v10)
References: <20071126200908.GA13287@sergelap.austin.ibm.com> <4750B6D5.7070607@kaigai.gr.jp> <20071201035820.GA7730@vino.hallyn.com>
In-Reply-To: <20071201035820.GA7730@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge,

> Is there any reason not to have a separate /etc/login.capbounds
> config file, though, so the account can still have a full name?
> Did you only use that for convenience of proof of concept, or
> is there another reason?

passwd(5) says the fifth field is optional and only used for
informational purpose (like ulimit, umask).

However, using any other separate config file is conservative
and better. One candidate is "/etc/security/capability.conf"
defined as the config file of pam_cap.

Thanks,
-- 
KaiGai Kohei <kaigai@kaigai.gr.jp>
