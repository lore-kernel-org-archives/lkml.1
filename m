Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbZFEW2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbZFEW2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZFEW22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:28:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:17135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZFEW21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:28:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,312,1241420400"; 
   d="scan'208";a="522185709"
Message-ID: <4A299C00.1010307@linux.intel.com>
Date: Fri, 05 Jun 2009 15:28:16 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: "N" symbols and System.map
References: <49FB7692.2000508@linux.intel.com> <20090605222650.GM29008@uranus.ravnborg.org>
In-Reply-To: <20090605222650.GM29008@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, May 01, 2009 at 03:24:18PM -0700, H. Peter Anvin wrote:
>> Hi all,
>>
>> right now, we filter out symbols that nm tag N, meaning "debugging 
>> symbols", from System.map.  However, at least on x86, the 
>> linker-generated symbol _end is tagged N, and in fact is the only N in 
>> the entire image.
>>
>> Are there other architectures which would suffer if N were included in 
>> System.map, or would that be a reasonable thing to do?
> 
> Peter - what is status here?
> 
> Do you see _end tagged N with -tip?
> We landed a lot of changes to vmlinux.lds there.
> 
> Needless to say I have not included N symbols for now.
> 

I haven't checked it for a bit, as my immediate need for it disappeared,
but I don't think it's changed.

	-hpa

