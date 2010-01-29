Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831Ab0A2NNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0A2NNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 08:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547Ab0A2NN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 08:13:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:49768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab0A2NN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 08:13:27 -0500
Message-ID: <4B62DEF6.8090203@suse.cz>
Date: Fri, 29 Jan 2010 14:13:26 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Hui Zhu <hui.zhu@windriver.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: Re: [PATCH] markup_oops.pl: fix get "No matching code found" when
 first line of range is the faulting instruction
References: <4B61357A.5080001@windriver.com> <20100128181240.GA9174@merkur.ravnborg.org>
In-Reply-To: <20100128181240.GA9174@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg napsal(a):
> On Thu, Jan 28, 2010 at 02:58:02PM +0800, Hui Zhu wrote:
>> Sorry guys, the prev mail for this patch is ugly.
>> I make a new mail for it.
> 
> Random updates to scripts/* historically often go
> in via the kbuild tree, so Michal added.

Thanks. I need to improve my filter :).


>> So I make a patch change this part to:
>> 	}
>> 	if ($state == 1) {
>> And this is another part is not OK too:
>> if ($center == 0) {
>> The first line $center will be 0, so I change the default value and decide to:
>> my $center  = -1;
>> if ($center == -1) {

Thanks, applied with a slightly shortened changelog.

Michal
