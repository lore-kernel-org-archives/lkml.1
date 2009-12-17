Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZLQF4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZLQF4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZLQF4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:56:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58282 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZLQF4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:56:36 -0500
Message-ID: <4B29C661.6090800@zytor.com>
Date: Wed, 16 Dec 2009 21:49:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Roland Dreier <rdreier@cisco.com>, Michal Marek <mmarek@suse.cz>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com>	<ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <4B29BFE8.1000502@zytor.com> <4B29C652.5080803@redhat.com>
In-Reply-To: <4B29C652.5080803@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 09:49 PM, Masami Hiramatsu wrote:
>>
>> I would strongly prefer the following solution as it solves this entire
>> class of problems globally, although I'd really want Michal's ACK for it:
> 
> Sure, agreed.
> BTW, is it possible user to overwrite this setting?
> 

Doing it this way means the user can override it on the make command line.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

