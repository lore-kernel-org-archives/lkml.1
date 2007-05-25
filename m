Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbXEYM5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbXEYM5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbXEYM5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:57:25 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:16009 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbXEYM5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=c55anBjayVYbELJtuGkAVa717B1IRdbxDZ+OTpvcbYjEo4SJHAQbXNTxh3xwpAyAkrY82lkTvMyvMrq2+FYlcc5IDl+Ljr/EWCqAIVZ6xzZ8zY9oDjnnHAbUIvtAgy1Ix5MlOKI7K2D3K2mWgnS0BEK/5EOIzdUZ7k/epcbVjO0=
Message-ID: <4cefeab80705250557w1baee0afn255e37436b6545a@mail.gmail.com>
Date: Fri, 25 May 2007 18:27:21 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 4
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Andrey Panin" <pazke@donpac.ru>, "Bret Towe" <magnade@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>
In-Reply-To: <1180095000.5864.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_190660_8748811.1180097841903"
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <1180095000.5864.48.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_190660_8748811.1180097841903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Richard,

On 5/25/07, Richard Purdie <richard@openedhand.com> wrote:
> On Fri, 2007-05-25 at 17:15 +0530, Nitin Gupta wrote:
> > Richard, can you please provide perf. results for this patch also?
> > Also, can you please mail back latest version of your LZO patch? In
> > meantime, I will try to include benchmarking support to the
> > 'compress-test' module.
>
> This version is 15% slower at decompression and about equal on
> compression.
>

If you don't mind, can you please try patch attached now? I have now
also rolled back that cpu_to_le16() change as Satyam suggested. I see
no other reason for this perf. loss as I made no other change!

Also, can you please verify if you are comparing your _safe_ version
with this patch? This patch does not include unsafe version and the
safe one is simply called lzo1x_decompress().


> I am however still strongly of the opinion that we should just use the
> version in -mm (which is my latest version).
>

I love this cleaned-up patch just sooo much! :)
Anyhow, if we can spend just small time scanning through these ~500
LOC to find reasons for any perf. loss, we will gain a lot!

Thanks,
Nitin

------=_Part_190660_8748811.1180097841903
Content-Type: application/x-bzip2; 
	name=patch_lzo_2.6.22-rc2_richard_test.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f23q3eu6
Content-Disposition: attachment; filename="patch_lzo_2.6.22-rc2_richard_test.bz2"

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
------=_Part_190660_8748811.1180097841903--
