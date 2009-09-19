Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZISH15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZISH15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 03:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbZISH14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 03:27:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60031 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZISH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 03:27:56 -0400
Message-ID: <4AB487FD.5060207@cs.helsinki.fi>
Date: Sat, 19 Sep 2009 10:27:57 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: ngupta@vflare.org
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>	 <1253227412-24342-3-git-send-email-ngupta@vflare.org>	 <1253256805.4959.8.camel@penberg-laptop>	 <Pine.LNX.4.64.0909180809290.2882@sister.anvils>	 <1253260528.4959.13.camel@penberg-laptop>	 <Pine.LNX.4.64.0909180857170.5404@sister.anvils> <1253266391.4959.15.camel@penberg-laptop> <4AB3A16B.90009@vflare.org>
In-Reply-To: <4AB3A16B.90009@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

Nitin Gupta wrote:
> It is understood that this swap notify callback is bit of a hack. I think
> we will not gain much trying to beautify this hack. However, I agree with
> Hugh's suggestion to rename this notify callback related function/variables
> to make it explicit that its completely ramzswap related. I will send a 
> path that affects these renames as reply to patch 0/4.

I don't quite agree and do think that my approach is a better long-term 
solution. That said, it's Hugh's call, not mine. Hugh?

			Pekka
