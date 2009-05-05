Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZEEIhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZEEIhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZEEIhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:37:33 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:60949 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZEEIhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VUTfXo1JkRCu0cYpUgX0p7lYyyWv3BM5Eq7t4+gBc+fGVRhVd7BaO9YByy/RI1zjvB
         hTiFO2HWqdiPLARTXaJomQUGrD7QbjJb3bVJZrb97OqMPTV2Kzm5fqrAkJIYlUfjO3cu
         AN3m7lh/H5yE2Z+n/eb6rwLrV5q6M1QER3aqQ=
MIME-Version: 1.0
In-Reply-To: <20090505082545.GE30220@wotan.suse.de>
References: <Pine.LNX.4.64.0905031514330.32397@melkki.cs.Helsinki.FI>
	 <20090505082545.GE30220@wotan.suse.de>
Date: Tue, 5 May 2009 11:37:32 +0300
X-Google-Sender-Auth: 96cbc2f7f31cabfb
Message-ID: <84144f020905050137k692fb9d6l3f25a03b12b65333@mail.gmail.com>
Subject: Re: [PATCH] SLQB: Coding style cleanups
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Tue, May 5, 2009 at 11:25 AM, Nick Piggin <npiggin@suse.de> wrote:
>> @@ -59,7 +59,7 @@ static inline void struct_slqb_page_wrong_size(void)
>>  /*
>>   * slqb_min_order: minimum allocation order for slabs
>>   */
>> -static int slqb_min_order = 0;
>> +static int slqb_min_order;
>
> I actually like explicit zero initializers. I think it has been
> a long time since this actually saved any memory with gcc.
>
> Yes yes, I know that anybody who can "read C" will read the
> implicit zero initializer anyway... however I just think it is
> a stupid thing for checkpatch to warn against.

OK. I guess I can drop those hunks. But from coding style of point
view we don't really do explicit zero initializers in the core
kernel...

                                       Pekka
