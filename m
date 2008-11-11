Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYKKX6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYKKX6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKKX56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:57:58 -0500
Received: from mail-gx0-f12.google.com ([209.85.217.12]:54813 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYKKX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M1dgD81FPYA2Dg7D0q/jykwTzsgwESlp5FHuxkaSxzYwGTsitixaxQQqf+apCWm0bk
         Hd8wQIfOp0IpW2yfRZTd/RobELN9mb1v4HofVxp8/CxWYp21fJi1iEa2eCEtuhov92Bb
         U3ueZaSMH0M4L++kU5/GEmsII+AeqIXDy2C6k=
Message-ID: <ef1cd66f0811111550x52d4bf1fv23c6e33c8a4b623d@mail.gmail.com>
Date: Tue, 11 Nov 2008 18:50:21 -0500
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [lm-sensors] [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do division with rounding
Cc: "Trent Piepho" <tpiepho@freescale.com>, djwong@us.ibm.com,
       khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
In-Reply-To: <20081111152007.ff508e26.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
	 <Pine.LNX.4.64.0811111459300.24267@t2.domain.actdsltmp>
	 <20081111152007.ff508e26.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/11/11 Andrew Morton <akpm@linux-foundation.org>:
> yup.  I wonder why the compiler doesn't do that for itself - is there a
> case where it will generate a different result?

The test program

    #include <stdio.h>
    int
    main()
    {
        signed int x = -1;
        printf("%d %d\n", x/2, x>>1);
        return 0;
    }

says

    0 -1

so it seems to make a difference.

All the best,
Jochen
-- 
http://seehuhn.de/
