Return-Path: <linux-kernel-owner+w=401wt.eu-S966285AbXDDCGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966285AbXDDCGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966284AbXDDCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:06:52 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:42257 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966283AbXDDCGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:06:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=w+144ksagyjS6KUt1XWWbgam2ykV4KMfgkb2LjXNqx1cgALBspJIbzzeHK3z/HP5dkhEB2b7/jFEGm/gkKW7JT53oHm72Z4u+gDJjJ8cU2fKDJ8H/RWK+FL0DfULy4r1BuvbSqbA6zbckYsBiL67qeGaXiIPUtnsZO7VuUvMl7g=  ;
X-YMail-OSG: OECbjRAVM1kncwqjJxTKdVYl0IED1o5cwR4y1tJVrNKOzE9srJBFSytL04j_B4vC.4oaZ5nGsg--
Message-ID: <46130830.7040307@yahoo.com.au>
Date: Wed, 04 Apr 2007 12:06:40 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paa Paa <paapaa125@hotmail.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F2534ADD292CC02D5ACAFBCF9670@phx.gbl>
In-Reply-To: <BAY20-F2534ADD292CC02D5ACAFBCF9670@phx.gbl>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paa Paa wrote:
>>> Q: What conclusion can I make on "hdparm -t" results or can I make 
>>> any conclusions? Do I really have lower performance with NCQ or not? 
>>> If I do, is this because of my HD or because of kernel?
>>
>>
>> What IO scheduler are you using? If AS or CFQ, could you try with 
>> deadline?
> 
> 
> I was using CFQ. I now tried with Deadline and that doesn't seem to 
> degrade the performance at all! With Deadline I got 60MB/s both with and 
> without NCQ. This was with "hdparm -t".
> 
> So what does this tell us?

Thanks. I believe CFQ contains some code to keep NCQ depths managable,
which might be causing the problem. I've cc'ed the CFQ author (Jens)
who might be able to give some more ideas.

Thanks for reporting!

-- 
SUSE Labs, Novell Inc.
