Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZFLPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZFLPbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZFLPbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:31:07 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:54825 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZFLPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:31:07 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: tomaz.mertelj@guest.arnes.si
Subject: Re: [lm-sensors] [PATCH] hwmon: Add driver for VIA CPU core	temperature
Date: Fri, 12 Jun 2009 10:31:02 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
References: <20090612_152510_043383.tomaz.mertelj@guest.arnes.si>
In-Reply-To: <20090612_152510_043383.tomaz.mertelj@guest.arnes.si>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121031.05738.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri June 12 2009, tomaz.mertelj@guest.arnes.si wrote:
> > 
> > The author had a problem in that routine -
> > try this one (32bit machines only) -
> > 
> > Mike 
> 
> DEBNAS:/home# for r in 0x1160 0x1161 0x1162 0x1163 0x1164 0x1165 0x1166 
> 0x1167
> 0x1168 0x1169 0x116a 0x116b 0x116c 0x1152 0x1153 ; do  ./rdmsrll $r ; 
> done
> MSR register 0x1160 => 08:04:83:94:bf:c2:39:c8
> MSR register 0x1161 => 08:04:83:94:bf:ce:12:88
> MSR register 0x1162 => 08:04:83:94:bf:d0:7a:a8
> MSR register 0x1163 => 08:04:83:94:bf:9e:1f:88
> MSR register 0x1164 => 08:04:83:94:bf:9c:ff:78
> MSR register 0x1165 => 08:04:83:94:bf:87:6e:18
> MSR register 0x1166 => 08:04:83:94:bf:a1:87:b8
> MSR register 0x1167 => 08:04:83:94:bf:f1:cc:b8
> MSR register 0x1168 => 08:04:83:94:bf:c6:22:08
> MSR register 0x1169 => 08:04:83:94:bf:cf:b8:68
> MSR register 0x116a => 08:04:83:94:bf:a3:57:d8
> MSR register 0x116b => 08:04:83:94:bf:b3:a8:d8
> MSR register 0x116c => 08:04:83:94:bf:ea:04:48
> MSR register 0x1152 => 08:04:83:94:bf:84:85:e8
> MSR register 0x1153 => 08:04:83:94:bf:d6:fb:18
> 
> I 
> I hope this is better.
>

The tool is broke - it is not reporting read failures.
Evidently those register ranges are masked out somewhere; 
will check on why/where.

Mike 
> Tomaz
> 
> 
> 
> 


