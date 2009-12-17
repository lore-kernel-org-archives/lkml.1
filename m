Return-Path: <linux-kernel-owner+w=401wt.eu-S934563AbZLQO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563AbZLQO6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbZLQO6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:58:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbZLQO6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:58:01 -0500
Message-ID: <4B2A4532.4050509@zytor.com>
Date: Thu, 17 Dec 2009 06:50:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Michal Marek <mmarek@suse.cz>, Roland Dreier <rdreier@cisco.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com> <ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <20091217054524.GA3931@merkur.ravnborg.org> <4B29C81E.2000704@zytor.com> <20091217080900.GA4010@merkur.ravnborg.org>
In-Reply-To: <20091217080900.GA4010@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 12:09 AM, Sam Ravnborg wrote:
> 
> Took a closer look at the patch.
> I think we should move this upwards in the Makefile so it take effect as soon as possible.
> Around the line where we do:
> 
> MAKEFLAGS += -rR --no-print-directory
> 

This makes sense.  I'm assuming Acked-by's I've received are still good,
and I'm going to commit this shortly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

