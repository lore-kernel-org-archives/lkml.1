Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZCUWnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZCUWnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZCUWnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:43:08 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:40107 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZCUWnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:43:07 -0400
Message-ID: <49C56D74.3030303@emcraft.com>
Date: Sun, 22 Mar 2009 01:43:00 +0300
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com,
       Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com> <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
In-Reply-To: <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Dan Williams wrote:
>> Have you ever tested this code path?
>>     
>
> Not this path, not yet.

You can disable the fallback to optimized synchronous functions and test
it with raid with dmaengine disabled. Or you can add support for
arbitrary coefficients in dmatest...

>   Which is exactly why I am holding back the md
> pieces.  We can collaborate on testing and stabilizing the api for a
> kernel cycle before turning on the raid6 conversion.
>   

Unfortunately we are not getting paid for this project any more so I
can't spend much time on it.

Regards, Ilya.

