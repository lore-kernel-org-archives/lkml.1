Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937Ab0AHSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0AHSu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871Ab0AHSu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:50:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0AHSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:50:57 -0500
Message-ID: <4B477E69.3060702@zytor.com>
Date: Fri, 08 Jan 2010 10:50:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Simon Horman <horms@verge.net.au>, Masami Hiramatsu <mhiramat@redhat.com>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       Sergei Trofimovich <slyfox@inbox.ru>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] Makefile: do not override LC_CTYPE
References: <20100108115745.GA14758@sepie.suse.cz> <1262952988-16563-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1262952988-16563-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2010 04:16 AM, Michal Marek wrote:
> Setting LC_CTYPE=C breaks localized messages in some setups. With only
> LC_COLLATE=C and LC_NUMERIC=C, we get almost all we need, except for not
> so defined character classes and tolower()/toupper(). The former is not
> a big issue, because we can assume that e.g. [:alpha:] will always
> include a-zA-Z and we only ever process ASCII input. The latter seems
> only affect arch/sh/tools/gen-mach-types, which we can handle separately.
> 
> So after this patch the meaning of ranges like [a-z], the behavior of
> sort and join, etc. should be the same everywhere and at the same time
> gcc should be able to print localized waring and error messages.
> LC_NUMERIC=C might not be necessary, but setting it doesn't hurt.
> 
> Reported-by: Simon Horman <horms@verge.net.au>
> Reported-by: Sergei Trofimovich <slyfox@inbox.ru>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

For what it's worth:

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

