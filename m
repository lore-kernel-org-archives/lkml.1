Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbYFLW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbYFLW1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYFLW07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:26:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:49787 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbYFLW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YbfUXkJdjEMROKcXXAg1ch8M1WMfLoL9QHo7t+Nd2nieIGqjwI9SxDjSZfgQGu5sst
         +JY7d3xqEHMuaTMDYWd9uQ4T5b9DyvCrT4C7Oy2gbwzdamfcjHu1kOFSp1ihLSnWMgXw
         dw4U0zJEDb31znTisLYXwcO24uPL3vTdWtchI=
Message-ID: <1ba2fa240806121526g2ed0c7u733d5620cb790eb6@mail.gmail.com>
Date: Fri, 13 Jun 2008 01:26:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Rik van Riel" <riel@redhat.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <48519577.8000402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <48519577.8000402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 12:30 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 06/12/2008 05:43 PM, Tomas Winkler wrote:
>>
>> On Thu, Jun 12, 2008 at 4:54 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>>
>>> This cuts the allocation to 10%, or (under) a page in all cases.
>>
>> Probably. it would be safe to use vmalloc for allocating txb anyway.
>> I'll give it a try.
>
> Why it wouldn't be "safe". I suggested it to you already, since allocating
> 64k by kmalloc for descriptors accessed only in kernel is crud. Moreover
> you're mixing the buffer with its descriptors here? Or what you're
> considering to vmalloc?
>
Not that. I just wasn't sure when I dropped the line  I'm not doing it
under some spinlock or something like that.
Tomas
