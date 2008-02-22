Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbYBVBda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbYBVBda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYBVBdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:33:22 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:36749 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYBVBdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:33:21 -0500
Message-ID: <47BE267E.3070508@davidnewall.com>
Date: Fri, 22 Feb 2008 12:03:50 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Willy Tarreau <w@1wt.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.24.1
References: <479A83DE.8020002@davidnewall.com> <20080202074406.GA31516@1wt.eu> <47A46BF8.6030306@davidnewall.com> <47BDDD4E.1080000@davidnewall.com> <20080221203640.GA21764@kroah.com> <20080221210058.GA27541@1wt.eu> <20080221213345.GB24191@kroah.com>
In-Reply-To: <20080221213345.GB24191@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 21, 2008 at 10:00:58PM +0100, Willy Tarreau wrote:
>   
>> I too agree to merge, it especially since it fixed several problems
>> for David. However, I would like to know first if the same problems
>> also happen with the 2.6 driver or if it is OK. The risk is getting
>> 2.4 fixed and not 2.6, which could cause regressions for people upgrading
>> from 2.4 to 2.6. Of course, a regression on a USB-serial adapter is
>> not dramatic, but it's a general principle to keep in mind that 2.6
>> should be safe (or at least actively being fixed) when merging driver
>> changes in 2.4.
>>     
>
> As far as I can tell, this was a backport of the current 2.6 driver, so
> it should not have fixes that are not already in 2.6.
>
> David, is that true?
>   

That is true.
