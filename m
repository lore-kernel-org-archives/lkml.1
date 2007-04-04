Return-Path: <linux-kernel-owner+w=401wt.eu-S2992546AbXDDDvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992546AbXDDDvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 23:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992560AbXDDDvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 23:51:42 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:49031 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992546AbXDDDvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 23:51:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=z7sQ/KxOrSDCvKad9KGzd8fVqQVOnk6eZrDWixFrf0ZJlsfBHH0tlyGrBbf3uMVThi8e2C+EqTZaFAtOD71hveI323McQa4gHwxk3djzcrZNIJ/oqy2xY21cUccMbXTXHJ0Kditxb4zQuPxFncyW7ucr7nx7YhYZ43cJAgTISWk=  ;
X-YMail-OSG: b.gu3jAVM1m2GxMhYLNrtaXsWnzhAYJj_YCN5961JTiek.7xsbItvFFCr54fjOvT8HXH1Mm6jA--
Message-ID: <461320C9.5030601@yahoo.com.au>
Date: Wed, 04 Apr 2007 13:51:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps: Move the page walker code to lib/
References: <7.486631555@selenic.com>
In-Reply-To: <7.486631555@selenic.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> Move the page walker code to lib/
> 
> This lets it get shared outside of proc/ and linked in only when
> needed.

I think it would be better in mm/.

So would clear_refs_pte_range, and clear_refs_write (in a more
generic form), IMO.

Sweet patchset, though.

-- 
SUSE Labs, Novell Inc.
