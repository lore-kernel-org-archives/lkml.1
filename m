Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZEDV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZEDV0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZEDV0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:26:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:53909 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbZEDV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:26:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,293,1239001200"; 
   d="scan'208";a="454042601"
Message-ID: <49FF5D76.8040204@linux.intel.com>
Date: Mon, 04 May 2009 14:26:14 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: "N" symbols and System.map
References: <49FB7692.2000508@linux.intel.com> <m2preso1wl.fsf@igel.home>	<20090501232149.GA28888@uranus.ravnborg.org>	<49FB8D27.3000305@linux.intel.com>	<20090504193336.GA10453@uranus.ravnborg.org> <m2skjkzhu6.fsf@igel.home>
In-Reply-To: <m2skjkzhu6.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> 
>> Andreas - can you explain what is happning here?
> 
> My best guess would be that it has to do with the fact that the _end
> symbol is attached to the .end section which is located before the debug
> sections, but the .end section is empty, so the symbol has the same
> address as the following debug section.  The ppc linker script does not
> attach the _end symbol to any section, so it becomes an absolute symbol.
> 

Yes; we used to do that in x86 too, but it messes up the post-processing 
for the relocatable kernel.

	-hpa
