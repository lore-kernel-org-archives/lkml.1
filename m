Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbYDRTTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbYDRTTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760760AbYDRTSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:18:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:7731 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760753AbYDRTSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rT32ICKIpoYeJC4DuApQTq5D3SBXnKpNJTiZfANEk9cbmFA8M4kud3x9zHh0Ih8pE8bJZPM+gdGIgRZNePDMaHtIS8rmwcikuMxj4ucmg0WVwpHV5egpLts3m4hXbpoDvHscEwXtQuFamKNpUCsk8nAqSQWpfzK+aly326Y7Bys=
Message-ID: <e2e108260804181218u70f096dfr864cdd13d1d4d2f3@mail.gmail.com>
Date: Fri, 18 Apr 2008 21:18:53 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: Matthew <jackdachef@gmail.com>
Subject: Re: Linux 2.6.25
Cc: torvalds@linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 5:37 PM, Matthew <jackdachef@gmail.com> wrote:
>  I've another "regression" to report for 2.6.25:
>
>  it's concerning much higher temperatures being read out by the
>  "coretemp" kernel-module in comparison to 2.6.24* series
>
>  e.g. where temperatures were around 40-47°C they are now constantly
>  jumping around 55-70°C (even in idle !)

The coretemp kernel module reports 25°C on my PC when idle, and 34°C
after having performed some computations (lmbench2). This looks
normal. This test has been performed with a vanilla 2.6.25 kernel and
a Core 2 Duo E6750 CPU (Asus motherboard). The 2.6.22 and 2.6.24
kernels report an incorrect temperature on the same system however
(10°C). So there is either an issue with the patches that have been
applied to your kernel or the behavior of the coretemp module for the
6600 and E6750 CPU's is different. Can you repeat the test with a
vanilla 2.6.25 kernel ?

(Added Rudolf Marek in CC, the coretemp author.)

Bart.
