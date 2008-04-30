Return-Path: <linux-kernel-owner+w=401wt.eu-S933624AbYD3XYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbYD3XYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbYD3XYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:24:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760061AbYD3XYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:24:42 -0400
Date: Wed, 30 Apr 2008 16:24:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Justin Mattock <justinmattock@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ACPI vs proc_create_data() mismerge (was Re: proc_dir_entry
 'info' already registered)
In-Reply-To: <20080501001002.GA4820@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0804301622120.2980@woody.linux-foundation.org>
References: <dd18b0c30804301538o35d0caf0x4a7e1c503cae0d6b@mail.gmail.com> <20080501001002.GA4820@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Alexey Dobriyan wrote:
>
> ACPI vs proc_create_data() mismerge.

Ahh, my bad. Sorry. It all looked fine and compiled, but yes, I didn't 
boot-test the merge - although I did ask Len to double-check it for me.

Usually these "fairly trivial" merges work without any issues, so I do the 
merge for the maintainer rather than sending an email back saying "it 
didn't merge cleanly, can you do the merge for me". I reserve the latter 
for just the things that look really complicated..

> acpi_device_dir() is NULL until all files are createst, so everyting is
> created in straight in /proc/ and creation code warns.

Thanks,

		Linus
