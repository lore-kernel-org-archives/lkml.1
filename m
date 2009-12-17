Return-Path: <linux-kernel-owner+w=401wt.eu-S935923AbZLQW24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935923AbZLQW24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935820AbZLQW2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:28:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935485AbZLQW2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:28:53 -0500
Message-ID: <4B2AB07D.5010007@zytor.com>
Date: Thu, 17 Dec 2009 14:28:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, rdreier@cisco.com,
       mmarek@suse.cz, tglx@linutronix.de, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,	LC_NUMERIC
 to C
References: <4B2A1761.4070904@suse.cz> <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org> <20091217220951.GB4236@merkur.ravnborg.org>
In-Reply-To: <20091217220951.GB4236@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 02:09 PM, Sam Ravnborg wrote:
> 
> This is IMO -next fodder and not urgent stuff.
> In the distant past something similar caused us troubles.
> 
> I assume that the patch posted by Roland fixes
> the relevant troubles with the awk script and that
> this patch is just for consistency.
> So in other words stuff for -next and not -rc1.
> 

No: the patch Roland posted fixes the problems with non-POSIX-compliant
awk (e.g. mawk), but it in turn requires this patch in order to not
break on non-C-locale-default systems (which are most systems nowadays.)

So -rc1.

	-hpa
