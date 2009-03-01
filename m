Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZCAQx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZCAQx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 11:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbZCAQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 11:53:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:27177 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbZCAQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 11:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L1RJyYKBdAVlCO5oWauyNhH6zwZ7MtM6buDQXrTL8mWSFVlKLKLgnzuIPo2vv6O/z9
         wuA4CyiGanEIYfXi6hbFK4+LEeXC9xF1Yzdew6yKRv4rnqbDJQusW6yzlSYxT4ItJi3G
         vd3eiKTHC4seDE/ehtarzfQOJ6v5ysQygfz6o=
Message-ID: <49AABD8B.2030809@gmail.com>
Date: Sun, 01 Mar 2009 17:53:31 +0100
From: Frank Seidel <kernalert.de@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Karsten Keil <kkeil@suse.de>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       linux-isdn@vger.kernel.org, Frank Seidel <frank@f-seidel.de>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Hannes Eder <hannes@hanneseder.net>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] isdn: reduce stack size of mISDN_dsp
References: <49AAB8B2.8060801@suse.de> <20090301165139.GA15287@pingi.kke.suse.de>
In-Reply-To: <20090301165139.GA15287@pingi.kke.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2009 05:51 PM, Karsten Keil wrote:
> I do not think we can use a static buffer here,
> we may have multiple instances.

Oh, i see. So i'll redo the patch with
kmalloc/kfree.

Thanks,
Frank
