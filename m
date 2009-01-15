Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbZAOVs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbZAOVs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZAOVsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:48:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:14067 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZAOVsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=slbO3AfVjefknprdxKxuXce+XP45Gk3ZUMU8oQ4sCf+iCLAJU2rsB3K1CA6nvbHq3A
         WvTl/bm8AdHJ0jG79kQ1tzbOR3RqYwo6Dtr2X4PLT5q7tH/e+BbA3Uc49PPSbCcO4VVz
         s8/8mtk8JLlzT2xLhgnMxyVmPmbMXLmFSGINY=
Message-ID: <8db1092f0901151348l47ffcec7m638180ca2cdbe4ce@mail.gmail.com>
Date: Thu, 15 Jan 2009 22:48:13 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Dieter Ries" <clip2@gmx.de>
Subject: Re: 2.6.29-rc1 does not boot
Cc: "Mike Travis" <travis@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <496FA4B6.3000607@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>
	 <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>
	 <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com>
	 <496FA4B6.3000607@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/15 Dieter Ries <clip2@gmx.de>:
> Mike Travis schrieb:
>> Hi Dieter and Maciej,

>> Can you try the attached patches on your system?  It boots on my system fine
>> now, but wasn't there a problem with resume as well?  (My test systems are
>> remote so suspending/resuming over the network is iffy.)
>
> I just tested it. The kernel does boot up, suspending to ram works
> perfectly, hibernating did also work, but I found an inconsistent lock
> state in dmesg afterwards. System is still fully functional
>

Suspend to disk works OK (unlike latest 2.6.29-rc1-git5). But suspend
to ram still doesn't work: resume immediately and hangs.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
