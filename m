Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbXF0EMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbXF0EMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbXF0ELw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:11:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbXF0ELw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:11:52 -0400
Message-ID: <4681E37A.9090708@redhat.com>
Date: Wed, 27 Jun 2007 00:11:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>	 <4681D45F.7080309@redhat.com> <a36005b50706262045g79c4accak21fea740fdc1bffd@mail.gmail.com>
In-Reply-To: <a36005b50706262045g79c4accak21fea740fdc1bffd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On 6/26/07, Rik van Riel <riel@redhat.com> wrote:
>> Since programs can get back free()d memory after a malloc(),
>> with the old contents of the memory intact, surely your
>> MAP_NONZERO behavior could be the default for programs that
>> can get away with it?
>>
>> Maybe we could use some magic ELF header, similar to the
>> way non-executable stack is handled?
> 
> No.  This is an implementation detail of the libc version.  The malloc
> as compiled today is expecting brk-ed memory to be zeroed.  This
> default can of course be changed (it's a simple define) but you cannot
> make this the default behavior for brk.

After going through the first malloc()/free() cycle, surely
the memory will no longer be zeroed on the second malloc() ?

What makes the first brk malloc so special?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
