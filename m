Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYANSQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYANSQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYANSQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:16:26 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37680 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYANSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:16:25 -0500
Message-ID: <478BA6B6.8050303@s5r6.in-berlin.de>
Date: Mon, 14 Jan 2008 19:15:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: possible recursive locking, 2.6.24-rc7
References: <20080113155142.M6056@visp.net.lb> <1200241360.7999.29.camel@lappy> <1200249866.7999.48.camel@lappy> <20080113192408.M31322@visp.net.lb>
In-Reply-To: <20080113192408.M31322@visp.net.lb>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote:
> I cannot reproduce, it is happened with rtorrent just randomly. But i will
> patch and keep watching.
> 
> On Sun, 13 Jan 2008 19:44:26 +0100, Peter Zijlstra wrote
>> On Sun, 2008-01-13 at 17:22 +0100, Peter Zijlstra wrote:
>> > It's epoll, this is a known issue and will be fixed soon. Thanks for
>> > reporting.
>> 
>> If its easy for you to reproduce, would you mind giving the following
>> patch a spin?

I may have a way to trigger another epoll "recursive-locking" trace at
will with current firewire development code.  Will try the annotation
patch when I have time.
https://bugzilla.redhat.com/show_bug.cgi?id=323411
http://marc.info/?l=linux1394-devel&m=120006699425902
-- 
Stefan Richter
-=====-==--- ---= -===-
http://arcgraph.de/sr/
