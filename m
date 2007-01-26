Return-Path: <linux-kernel-owner+w=401wt.eu-S965065AbXAZLqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965065AbXAZLqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbXAZLqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:46:25 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:28301 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933206AbXAZLqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:46:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gUq1QA594tJAuveSEO0fZNoP3sjf6p4GPmbR8c2P12PUePIjSiDlonu4/2rnhbc0+Iq0/AyfZCvt9w0tCFBJVEcXSk6po0YHqARpP6sSTJU7+YcDksyvdqL5MyM0wj4M8SSANLdIh/246qJWdUf9gXBRKtMX/N22KB+7nGh9aiE=  ;
X-YMail-OSG: wbjifGwVM1lbmNtxMimQjeWrFK7CJKnHMMdk8RPWQp6PhOyv9pYw.05XxjtD2za6POsZJh9WZg--
Message-ID: <45B9EA01.7010204@yahoo.com.au>
Date: Fri, 26 Jan 2007 22:46:09 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com> <45B9A00C.4040701@yahoo.com.au> <Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 26 Jan 2007, Nick Piggin wrote:
> 
> 
>>Christoph Lameter wrote:
>>
>>>Add NR_MLOCK
>>>
>>>Track mlocked pages via a ZVC
>>
>>I think it is not quite right. You are tracking the number of ptes
>>that point to mlocked pages, which can be >= the actual number of pages.
> 
> 
> Mlocked pages are not inherited. I would expect sharing to be very rare.

Things like library and application text could easily have a lot of
sharing.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
