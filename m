Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbXE2VNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbXE2VNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXE2VN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:13:27 -0400
Received: from gw.goop.org ([64.81.55.164]:39543 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXE2VNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:13:25 -0400
Message-ID: <465C9776.20901@goop.org>
Date: Tue, 29 May 2007 14:13:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Tell modpost that any reference from .note* is OK
References: <465C8E10.8040608@goop.org> <20070529210748.GC7738@uranus.ravnborg.org>
In-Reply-To: <20070529210748.GC7738@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, May 29, 2007 at 01:33:20PM -0700, Jeremy Fitzhardinge wrote:
>   
>> .note* sections are ELF notes, which are typically used by external
>> tools to examine the kernel image.  Since this is removed from any
>> runtime consideration, it's OK to reference any section from a .note*
>> section.
>>
>> As a side-effect, this changes secref_whitelist to accept a NULL "atsym"
>> pointer, allowing it to be called when "before" is NULL.  This is
>> needed for .note sections since they don't necessarily have any
>> symbols, and it also allows the .got2 check to to be folded into the
>> normal whitelist checks.
>>     
>
> I did it a bit different. Adding .note to init_section_ref_ok +
> exit_section_ref_ok is much simpler.
> Next patch will move .got2 there too.
>   

Oh, yeah, that's simpler.  OK.

    J
