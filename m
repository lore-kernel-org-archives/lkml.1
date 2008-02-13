Return-Path: <linux-kernel-owner+w=401wt.eu-S1765444AbYBMT2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765444AbYBMT2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbYBMT2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:28:25 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:24574 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758634AbYBMT2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:28:24 -0500
From: Frans Pop <elendil@planet.nl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [2.6.25-rc1] System no longer powers off after shutdown
Date: Wed, 13 Feb 2008 20:28:20 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200802111623.38478.elendil@planet.nl> <200802131239.14305.elendil@planet.nl> <20080213165837.GA10129@suse.de>
In-Reply-To: <20080213165837.GA10129@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132028.20620.elendil@planet.nl>
X-OriginalArrivalTime: 13 Feb 2008 19:28:21.0075 (UTC) FILETIME=[97B92A30:01C86E76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Greg KH wrote:
> > So, just on the off chance, I applied the patch below and bingo, the
> > system powers off again. I doubt this will be the correct solution, but
> > just in case it is, here's my signed off. A comment why the double put
> > is needed would probably be good though.
>
> There is a bug in the cpufreq kref logic that makes this "double put"
> necessary.  A real fix has already been posted to solve this issue, and
> I think it should be on it's way to Linus for -rc2 already.

OK, great.

Do you think that #6879 could be caused by a similar issue elsewhere in the 
tree? Can you give me some pointers on how I could find out (debugging to 
enable, instrumentation to add)?

> Please let me know if -rc2 comes out without this needed fix.

Will do.
