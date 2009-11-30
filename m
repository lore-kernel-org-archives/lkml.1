Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZK3KgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZK3KgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZK3KgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:36:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:38239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZK3KgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:36:00 -0500
Message-ID: <4B13A015.8010407@suse.cz>
Date: Mon, 30 Nov 2009 11:36:05 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-2?Q?An=EDbal_Monsalve_?= =?ISO-8859-2?Q?Salazar?= 
	<anibal@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-kbuild.git
References: <4B0E73E1.50900@suse.cz>	<20091126193750.GA15453@merkur.ravnborg.org>	<20091127152211.55043dbb.sfr@canb.auug.org.au>	<4B0F9F0D.6010601@suse.cz> <20091130085713.75f56423.sfr@canb.auug.org.au>
In-Reply-To: <20091130085713.75f56423.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2009 22:57, Stephen Rothwell wrote:
> On Fri, 27 Nov 2009 10:42:37 +0100 Michal Marek <mmarek@suse.cz> wrote:
>> I plan to maintain such a branch, but I thought I would base the
>> for-next branch on top of it, so that you get everything in one pack. Or
>> would you still prefer to have two kbuild branches in linux-next, so
>> that you can remove the for-next branch if necessary and keep the
>> for-current branch? Just tell me what fits you best.
> 
> Running a for-current branch allows you to queue up urgent fixes without
> disrupting your for-next branch.  I will merge such a branch early on
> (actually before I do my first build) so that I don't have to worry about
> problems that are already have fixes pending for to be merged by Linus in
> his current tree.  Also, as you say, if I have problems with your
> for-next branch, it does not affect the more urgent patches.

OK, I created a for-linus branch in git://repo.or.cz/linux-kbuild.git.
Currently it's empty, as there are no urgent kbuild fixes for 2.6.32.

Michal
