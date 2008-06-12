Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYFLVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYFLVb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYFLVbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:31:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46633 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYFLVbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WjNhlYYQoCb4o09I3BPYfngmUpQhn0ei+FAq1RKoMmkOxYKAyyoKCGdg4y+d6+YnrA
         dhgYiRbTOofcLy6ugLt4RGmuuIdLr3f+LzcRuJHbO/qPAeDpvq9belxCtlyw/ZZKXWbc
         ym6VEHWByS0MNpHXmI00Ba6HDvauulgcEJLEY=
Message-ID: <48519577.8000402@gmail.com>
Date: Thu, 12 Jun 2008 23:30:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, Rik van Riel <riel@redhat.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>	 <20080612093833.0fb9cdd6@bree.surriel.com>	 <1213278884.3936.15.camel@johannes.berg> <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
In-Reply-To: <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2008 05:43 PM, Tomas Winkler wrote:
> On Thu, Jun 12, 2008 at 4:54 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> This cuts the allocation to 10%, or (under) a page in all cases.
> 
> Probably. it would be safe to use vmalloc for allocating txb anyway.
> I'll give it a try.

Why it wouldn't be "safe". I suggested it to you already, since allocating 64k 
by kmalloc for descriptors accessed only in kernel is crud. Moreover you're 
mixing the buffer with its descriptors here? Or what you're considering to vmalloc?
