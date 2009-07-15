Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZGORzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZGORzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbZGORzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:55:20 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:32376 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755843AbZGORzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:55:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gBTgd14InGr/k59eEkJhxkEPNHbZ5nBVoEkPV920cgRInpKQR4boJc04BQnM+/+Y7oBchjxOJBNYLA4wQRmkTC1snIInVzitKA8RgKOwvPnYxyV7AwwhE3798/qc26H7aaD77mL4Q2ss/rTdpIXizo6U4z9EEESAFS6UM5DKzWY=  ;
X-YMail-OSG: yvGlVgYVM1kfkLnFvEx0IjP2mk_6fYWtoEPY8oJDWiC7dZ0YIjDwCJSQkO0NbsSRqpDwY35vcvVXYAL79cdUCVBJ1Nj957yGyHLKo4qSJLrv8btOxeUn7r91vymLuNW0Ts10tsCIDbhOz1Anyieq82uRC9l8Tw96NVUEBkwUCvSNFQm75GbvKB9UC3BC3XoyxFgtAFxscF0afLntMFCSSLFBSVHG6DJuyYPD97x8QLn6AhAkQI79pXTG6pIEDouR_ht9F6OyFW1X4j0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: Kernel Oops when trying to suspend with ubifs mounted on block2mtd mtd device on 2.3.31-rc2
Date: Wed, 15 Jul 2009 10:55:17 -0700
User-Agent: KMail/1.9.10
Cc: Tobias Diedrich <ranma@tdiedrich.de>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, David.Woodhouse@intel.com
References: <20090715122051.GA1439@yamamaya.is-a-geek.org> <4A5DD233.7090702@nokia.com>
In-Reply-To: <4A5DD233.7090702@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907151055.17959.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 July 2009, Adrian Hunter wrote:
> Looks like it might be related to MTD driver model updates.

Not the sysfs support ... more likely the patch adding cls_suspend()
support, 15bce40cb3133bcc07d548013df97e4653d363c1, is goofed.  Maybe
it's invoking suspend on the wrong device node...



