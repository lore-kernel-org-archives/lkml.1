Return-Path: <linux-kernel-owner+w=401wt.eu-S1751089AbZLZFPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbZLZFPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 00:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZLZFPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 00:15:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZLZFPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 00:15:14 -0500
Message-ID: <4B359BC0.3080808@zytor.com>
Date: Fri, 25 Dec 2009 21:14:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Simon Horman <horms@verge.net.au>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Michal Marek <mmarek@sues.cz>,
       Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] Makefile: Unexport LANG
References: <20091224111300.GA31932@verge.net.au> <4B359166.3050106@redhat.com>
In-Reply-To: <4B359166.3050106@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2009 08:30 PM, Masami Hiramatsu wrote:
>>  
>>  # Avoid funny character set dependencies
>> +unexport LANG
>>  unexport LC_ALL
>>  LC_CTYPE=C
>>  LC_COLLATE=C
> 

At this point, it seems to me that we should just LC_ALL=C and be done
with it (see other thread.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

