Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYG2V1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYG2V1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYG2V10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:27:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYG2V1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:27:25 -0400
Message-ID: <488F8B1B.3080500@kernel.org>
Date: Tue, 29 Jul 2008 14:26:51 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Clemens Ladisch <clemens@ladisch.de>, lkml <linux-kernel@vger.kernel.org>,
       bob.picco@hp.com, venkatesh.pallipadi@intel.com,
       Vojtech Pavlik <vojtech@suse.cz>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch 2.6.26] /dev/hpet - fixes and cleanup
References: <200807221508.56672.david-b@pacbell.net> <200807230912.49850.david-b@pacbell.net> <4888691D.5090307@ladisch.de> <200807251255.35675.david-b@pacbell.net>
In-Reply-To: <200807251255.35675.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> 
> On x86_64 the vsyscall stuff should kick in for gettimeofday()
> when HPET is in use, eliminating the need for /dev/hpet mmapping.
> 
> I don't really know vsyscalls ... but if that could be done on
> i386 systems, the last argument for /dev/hpet would seem gone...
> 

i386 already uses vsyscalls.

	-hpa
