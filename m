Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYHGX6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYHGX6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYHGX6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:58:38 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:17731 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbYHGX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NkqutEHH82qN6KDz+MmR+39cgFgMDBx506xJkyqzyQcSiVgGLcN8V3WkWSgpeUxPlc
         2/lbvHyXRWiAT14PUpJjpP88al1RltZX81KkGRkzVivhcLonBlF1i/NzsERSP3GEl9iT
         9Yk0bbqpc0ADq2rzaBLbkyEAF/fgwgwX1HHb4=
Message-ID: <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>
Date: Thu, 7 Aug 2008 16:58:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander Huemer" <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.27-rc1 mtrr fixes do not work
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <489B85A3.7030500@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at> <200808072214.28922.rjw@sisk.pl>
	 <7E82351C108FA840AB1866AC776AEC46092119D3@orsmsx505.amr.corp.intel.com>
	 <86802c440808071323o3021a90rae51223187bfd47b@mail.gmail.com>
	 <86802c440808071326m21cff146s3fb5e6118a58a2ca@mail.gmail.com>
	 <489B73B7.4090705@sbg.ac.at>
	 <86802c440808071616o23dde07atd694b45375f9d6ac@mail.gmail.com>
	 <86802c440808071617i1344e595wb9cc7c2bf75a5b3f@mail.gmail.com>
	 <489B85A3.7030500@sbg.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 4:30 PM, Alexander Huemer
<alexander.huemer@sbg.ac.at> wrote:
> Yinghai Lu wrote:

>>> can you put "debug" in command line too?
>>>
>>
>> without mtrr_chunk_size etc in command line...please
>>
>
> http://xx.vu/~ahuemer/dmesg_3.txt
>

do you have
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

in your .config?

YH
