Return-Path: <linux-kernel-owner+w=401wt.eu-S1761660AbYAKPoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660AbYAKPoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760199AbYAKPoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:44:16 -0500
Received: from as4.cineca.com ([130.186.84.213]:38399 "EHLO as1.cineca.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760190AbYAKPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:44:15 -0500
Message-ID: <47878EC1.4000907@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Newall <david@davidnewall.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net> <4787779B.1070100@davidnewall.com>
In-Reply-To: <4787779B.1070100@davidnewall.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jan 2008 16:44:01 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Andrea Righi wrote:
>> [I/O-intensive] processes can noticeably impact the system responsiveness
>> for some time and playing with tasks' priority is not always an
>> acceptable solution.
>>   
> 
> Why?
> 

Well, I mean, we can't use 'nice' to grant less priority for the I/O
intensive app, because the I/O intensive app itself doesn't need a lot
of CPU. Instead, the I/O-bound app eats all the available I/O bandwidth,
that's a different issue.

-Andrea
