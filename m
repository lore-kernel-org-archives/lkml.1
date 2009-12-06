Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZLFTM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZLFTM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZLFTMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:12:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193AbZLFTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:12:54 -0500
Message-ID: <4B1C01F4.8020304@zytor.com>
Date: Sun, 06 Dec 2009 11:11:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mingo@elte.hu, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH 1/1] X86: use explicit register name for get/put_user
References: <1260091808-8053-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1260091808-8053-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2009 01:30 AM, Jiri Slaby wrote:
> 
> I don't know if this could ever cause any problems, but changing
> the input to an explicit register ("a") makes it cleaner in my eyes.
> There is no need of the back reference.
> 

It can't: the backreference refers to only the information that is in
the register constraint, not to anything else.  I really would prefer
avoiding any changes to working code that aren't justified, simply
because every time we change an asm() we risk tickling a new obscure bug
in some old version of gcc.

As such,

Nacked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

