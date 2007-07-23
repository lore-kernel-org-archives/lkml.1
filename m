Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbXGWGsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbXGWGsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbXGWGsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:48:38 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:40570 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758985AbXGWGsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:48:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=03iUO3uHH5CTWpJryaIxnvg1YYens10/zQo0v/KilNKIa/kFZyxvbQGuGxwmarS3v6VE6aMQwqpfswzSkdRIQ0gZBwDvXjMs7H9HIuEK8teMtER+wSOXeH9RTau6jDdGBirPIEhs08+TQyciMZj8obih6MiQe5bd4i1J7lvsYig=  ;
X-YMail-OSG: frkylg4VM1kYKRM6mtWOIH0ZASoarbsxGg3vCqYJ11eFlBXVAoEJV9hb8BoXQCPrvN.MhNBAEA--
Message-ID: <46A44F3C.5080301@yahoo.com.au>
Date: Mon, 23 Jul 2007 16:48:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, airlied@linux.ie,
       linux-kernel@vger.kernel.org
Subject: Re: cmpxchg is not available to generic code
References: <20070719000549.1e57b5b2.akpm@linux-foundation.org>	 <20070719.002716.30181989.davem@davemloft.net>	 <21d7e9970707190115r15e691d5s123c9889a8ebd8a5@mail.gmail.com>	 <20070719012141.47911bd7.akpm@linux-foundation.org> <21d7e9970707190123n328300a6m8debe274b959ab30@mail.gmail.com>
In-Reply-To: <21d7e9970707190123n328300a6m8debe274b959ab30@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On 7/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Thu, 19 Jul 2007 18:15:03 +1000 "Dave Airlie" <airlied@gmail.com> 
>> wrote:
>>
>> > Maybe we could add CONFIG_HAVE_CMPXCHG and let DRM depend on it..
>>
>> That would certainly be better than adding a sprinkle of architectures
>> in DRM Kconfig dependencies.
>>
>> I don't know how important DRM is on ARM.  Zero?
>>
> 
> I'd guess zero I suppose if you wanted you could hook up a PCI
> graphics card on ARM, but if you do that I think you could implement
> cmpxchg :-)

ARM does the locked load / store conditional thing which is at least as
strong as cmpxchg, so I imagine it could implement this API in kernel
and userspace quite easily if needed.

-- 
SUSE Labs, Novell Inc.
