Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXAZM1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXAZM1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXAZM1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:27:30 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:45939 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751652AbXAZM1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:27:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=qmMdrUoW0mS6DhzJ4lcpmuQ55Y1Yt2C0ryzJ/gqUmdoFisD/a2J0/esHTL/Zz3ztJX0qMu7eX/AjXNuprhcDrBAia2BaI/fjtgGrAiEX4cR3YiqofuZ5crKEsl8QP2mHZMTi2sZh15wBj5IeEifmA7eQ0epAneRY2jmhvPI82Vs=  ;
X-YMail-OSG: FjlW_ZkVM1n3pLmYV6YWkxVwd.6FbI_fz6vjXPXT_y2O1wrWwe8e9ejKbBbbZfj4dGEhX4PpeA--
Message-ID: <45B9F3A3.6080003@yahoo.com.au>
Date: Fri, 26 Jan 2007 23:27:15 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Add __GFP_MOVABLE for callers to flag allocations
 that may be migrated
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie> <20070125234518.28809.86069.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070125234518.28809.86069.sendpatchset@skynet.skynet.ie>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> It is often known at allocation time when a page may be migrated or
> not. This patch adds a flag called __GFP_MOVABLE and a new mask called
> GFP_HIGH_MOVABLE.

Shouldn't that be HIGHUSER_MOVABLE?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
