Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXGXQ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXGXQ4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXGXQ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:56:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39361 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXGXQ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:56:33 -0400
Date: Tue, 24 Jul 2007 18:56:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
In-Reply-To: <46A5E39D.7030009@shadowen.org>
Message-ID: <Pine.LNX.4.64.0707241854140.18990@fbirervta.pbzchgretzou.qr>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A53F3A.7060509@intel.com>
 <46A5E39D.7030009@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 24 2007 12:33, Andy Whitcroft wrote:
>
>> Warning on multiple declarations on a line is nice, but IMO really too
>> verbose (why is "int i, j;" bad? Did C somehow change syntax today?).
>
>No the normal response is two fold:
>
>1) "what the heck are i and j those are meaningless names"

Can we at least assume the submitter is sane in some ways?
i and j are picked for obvious iterater values - you would not want
verbosify that to fruit_iterator and process_iterator or whatever
because it's a hell lot more typing.
It takes more than a few Perl regexes to actually grasp the semantics
of whether "i" is useful or not.


	Jan
-- 
