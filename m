Return-Path: <linux-kernel-owner+w=401wt.eu-S1765328AbXGYH6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765328AbXGYH6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXGYH6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:58:25 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:39649 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753662AbXGYH6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:58:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=scv3K8oypKiN67ejdKLaOFwwb3bBy2c5C7LTDGDw9vkvU7kvytvaiLER84sD9myxGCGXjZn94zgYQzT444HnEN9lDugEExtsQ5EtPCPGmapvI2FLwUcxEmi58U1G7G4ui8EgN+Gy88bVqEyDCzV+yKf8gpe08ICpEUdOJ3BcU/g=  ;
X-YMail-OSG: 18iuSJsVM1lZ3cq7zHT5ZV0lyiZCIk_adUi144U9DkaQXFK9Qv0fx9dekEkEvJ1HXmnEJhrtjg--
Message-ID: <46A70299.50809@yahoo.com.au>
Date: Wed, 25 Jul 2007 17:58:17 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: david@lang.hm, Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
References: <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au> <Pine.LNX.4.64.0707242252250.2229@asgard.lang.hm> <46A6E80B.6030704@yahoo.com.au> <Pine.LNX.4.64.0707242316410.2229@asgard.lang.hm> <46A6FAD8.6050107@yahoo.com.au> <20070725074931.GA5125@elte.hu>
In-Reply-To: <20070725074931.GA5125@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>And yet despite my repeated pleas, none of those people has yet spent 
>>a bit of time with me to help analyse what is happening.
> 
> 
> btw., it might help to give specific, precise instructions about what 
> people should do to help you analyze this problem.

Ray has been the first one to offer (thank you), and yes I have asked
him for precise details of info to collect to hopefully work out what
is happening with his first problem.

For the general "it feels better for me" it is harder, but not as hard
as CPU scheduler. We can measure various types of IO waits, swap in/out
events, swap prefetch events and successfulness; see what happens to
those as we change swappiness or vfs_cache_pressure etc.

-- 
SUSE Labs, Novell Inc.
