Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbYEAAHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbYEAAHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYEAAHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:07:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbYEAAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:07:34 -0400
Date: Wed, 30 Apr 2008 17:07:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Justin Mattock <justinmattock@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ACPI vs proc_create_data() mismerge (was Re: proc_dir_entry
 'info' already registered)
In-Reply-To: <20080501001002.GA4820@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.1.10.0804301706590.5947@woody.linux-foundation.org>
References: <dd18b0c30804301538o35d0caf0x4a7e1c503cae0d6b@mail.gmail.com> <20080501001002.GA4820@martell.zuzino.mipt.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Alexey Dobriyan wrote:
> 
> acpi_device_dir() is NULL until all files are createst, so everyting is
> created in straight in /proc/ and creation code warns. 

Ok, I tested this on a laptop, it works for me. Committed. Thanks again,

		Linus
