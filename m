Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZA2UmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZA2UmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZA2UmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:42:13 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:55983 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZA2UmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:42:12 -0500
Message-ID: <49821476.7060500@oracle.com>
Date: Thu, 29 Jan 2009 12:41:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-01-29-02-29 uploaded (wimax)
References: <200901291030.n0TAUhRI003046@imap1.linux-foundation.org> <4981EC35.1030306@oracle.com> <200901291058.50466.inaky@linux.intel.com>
In-Reply-To: <200901291058.50466.inaky@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4982147A.015E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inaky Perez-Gonzalez wrote:
> On Thursday 29 January 2009, Randy Dunlap wrote:
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-01-29-02-29 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>> Build fails with:
>>
>> ERROR: "d_level_wimax" [net/wimax/wimax.ko] undefined!
>> ERROR: "d_level_size_wimax" [net/wimax/wimax.ko] undefined!
> 
> On it, Toralf Foerster just reported it.
> 
> I got the fix, I am now verifying it.
> 
> How do you guys generate all this configs? I thought I had tried all
> possible combinations and I guess I was wrong...

I just have a 'make randconfig' machine (repeat, repeat, ...).

-- 
~Randy
