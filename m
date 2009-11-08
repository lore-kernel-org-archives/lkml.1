Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZKHQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZKHQgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZKHQgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:36:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZKHQgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:36:54 -0500
Message-ID: <4AF6F393.5050002@zytor.com>
Date: Sun, 08 Nov 2009 08:36:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, hare@suse.de,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add back _end symbol that is missing	from
 Symbol.map
References: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org> <tip-d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76@git.kernel.org> <20091108113805.GA11847@merkur.ravnborg.org>
In-Reply-To: <20091108113805.GA11847@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2009 03:38 AM, Sam Ravnborg wrote:
> 
> I'm afraid this will break a RELOCTABLE i386 kernel.
> 
> We fixed this up some time ago where we had to
> move the symbol definition inside a section
> to prevent the symbol being absolute.
> 

It's also possible to have a whitelist of "known relative" symbols in
reloc.c, just as we have a blacklist of "known absolute" symbols.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

