Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558Ab0AIAKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0AIAKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538Ab0AIAKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:10:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0AIAKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:10:31 -0500
Message-ID: <4B47C94E.8070302@redhat.com>
Date: Fri, 08 Jan 2010 19:09:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Sergei Trofimovich <slyfox@inbox.ru>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
References: <20100108115745.GA14758@sepie.suse.cz> <1262952988-16563-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1262952988-16563-1-git-send-email-mmarek@suse.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Michal Marek wrote:
> Setting LC_CTYPE=C breaks localized messages in some setups. With only
> LC_COLLATE=C and LC_NUMERIC=C, we get almost all we need, except for not
> so defined character classes and tolower()/toupper(). The former is not
> a big issue, because we can assume that e.g. [:alpha:] will always
> include a-zA-Z and we only ever process ASCII input. The latter seems
> only affect arch/sh/tools/gen-mach-types, which we can handle separately.

Hmm, this also affects arch/x/tools/gen-insn-attr-x86.awk.
Could you also wrap it?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

