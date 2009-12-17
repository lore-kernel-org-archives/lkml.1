Return-Path: <linux-kernel-owner+w=401wt.eu-S1763875AbZLQGbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763875AbZLQGbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763319AbZLQGbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:31:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39225 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762709AbZLQGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:31:12 -0500
Message-ID: <4B29CE79.8000003@zytor.com>
Date: Wed, 16 Dec 2009 22:23:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com>	<aday6l25gnm.fsf@roland-alpha.cisco.com>	<20091217054524.GA3931@merkur.ravnborg.org>	<4B29C81E.2000704@zytor.com> <adatyvq5dl5.fsf@roland-alpha.cisco.com>
In-Reply-To: <adatyvq5dl5.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 10:17 PM, Roland Dreier wrote:
> 
>  > +# Avoid funny character set dependencies
>  > +LC_ALL=
>  > +LC_CTYPE=C
>  > +LC_COLLATE=C
>  > +LC_NUMERIC=C
>  > +export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
> 
> Yes, this plus my first patch (only touching the awk script, not the
> Makefile) make sense to me.

Right, of course.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

