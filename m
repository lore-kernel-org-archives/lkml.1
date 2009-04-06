Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZDFUps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZDFUps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZDFUpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:45:39 -0400
Received: from mga06.intel.com ([134.134.136.21]:51583 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378AbZDFUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:45:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,332,1235980800"; 
   d="scan'208";a="504074017"
Message-ID: <49DA69DD.2090203@linux.intel.com>
Date: Mon, 06 Apr 2009 13:45:17 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: Re: kernel oops with latest git v2.6.29-9516-g0221c81
References: <49DA6168.2020701@gmail.com> <200904062234.29481.a.miskiewicz@gmail.com>
In-Reply-To: <200904062234.29481.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz wrote:
> On Monday 06 of April 2009, Riccardo Magliocchetti wrote:
>> Hi,
>>
>> i've updated the kernel to latest git and now it's oopsing.
>>
>> I've uploaded 3 pictures taken from a camera here:
>>
>> http://yfrog.com/41oops1j
>> http://yfrog.com/bcoops2j
>> http://yfrog.com/bcoops3j
> 
> You hit the same thing as me:

I'm not so sure of that.

All the oopses from the URL above seem to have the "F" flag set for the modules, which implies that
the modules you're using don't match the kernel you are running. That's a pretty bad deal
in general, and more likely than not to be the cause of any weird crashes you're getting...
