Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZAJM3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZAJM3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 07:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZAJM3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 07:29:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:46185 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZAJM3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 07:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HXdqGeQK3JJlw7XDBuiU2mkYUre85JS+Jr4PdgJdkhhKh+bGDRVhiB9/BbnHhdd4sE
         YuhAjEaheb0LRGDmXgJluEJ7VqAgnIPVQwD38D3MtPvOQqUc6VqCFT2tyO4JpCTkOcGF
         xyq7M6ZDP8I9RRmwbp1jTyBaqmASqryvHuqxc=
Message-ID: <2f11576a0901100429h415d3a87o40ba4849120832c8@mail.gmail.com>
Date: Sat, 10 Jan 2009 21:29:04 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] add b+tree library
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
In-Reply-To: <1231587428.3803.0.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231584446.3685.21.camel@johannes>
	 <2f11576a0901100302s5132a1b9p11c62e27aa9a06f8@mail.gmail.com>
	 <1231587428.3803.0.camel@johannes>
X-Google-Sender-Auth: 511a431d0276f4d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > This adds a b+tree library. The API and memory layout is documented in
>> > the header file lib/btree.h. There are tree versions for 32, 64 and
>> > 128 bit keys as well as unsigned long (32/64 depending on platform).
>>
>> Can this library remove the btree code in some btree based filesystem?
>
> Joern is going to use it for logfs, that's the point. Not sure about
> other filesystems.

Why can't you investigate other filesystem?
if this library is used by only one fs, why does this library routine
need to linux/lib/ directory?
