Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZCSHEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZCSHEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZCSHEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:04:34 -0400
Received: from mga06.intel.com ([134.134.136.21]:42565 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081AbZCSHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,388,1233561600"; 
   d="scan'208";a="499017934"
Message-ID: <49C1EE7D.5070507@linux.intel.com>
Date: Thu, 19 Mar 2009 15:04:29 +0800
From: chen gong <gong.chen@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: nonboot cpu on SMP suspend
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com> <200903190000.33572.rjw@sisk.pl>
In-Reply-To: <200903190000.33572.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki 写道:
> On Wednesday 18 March 2009, Li Yang wrote:
>> Hi all,
>>
>> I'm curious why we need to un-plug all the nonboot cpus before suspend
>> and start them all over again after the suspend(ACPI sleep)?  I mean
>> if we can bring the booting cpu back to the exact state as before
>> suspend, why can't we just do the same for non-booting cpus?  And that
>> will be much faster.  Any thought?  Thanks.
> 
> Because we need to enter the BIOS with one CPU on-line only.
> 
You mean only one CPU can be supported by BIOS when suspend/resume ?
