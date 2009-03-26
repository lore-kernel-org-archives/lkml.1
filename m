Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZCZRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZCZRWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbZCZRWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:22:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:39315 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbZCZRWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:22:16 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3 0/3] new memory_accessor interface and usage
References: <1237239379-24186-1-git-send-email-khilman@deeprootsystems.com>
	<200903161610.06469.david-b@pacbell.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 26 Mar 2009 10:22:10 -0700
In-Reply-To: <200903161610.06469.david-b@pacbell.net> (David Brownell's message of "Mon\, 16 Mar 2009 16\:10\:06 -0700")
Message-ID: <874oxgi4hp.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> writes:

> On Monday 16 March 2009, Kevin Hilman wrote:
>> This series adds an interface by which other kernel code can read/write
>> persistent memory such as I2C or SPI EEPROMs, or devices which provide
>> NVRAM.  Use cases include storage of board-specific configuration data
>> like Ethernet addresses and sensor calibrations, etc.
>
> Looks OK to me.  Once this goes in (with support for I2C and SPI EEPROMs)
> then various RTC's NVRAM support can be updated too ... at a quick count,
> that makes nine more drivers that can easily support this.
>
> I kind of like letting Linux have the option of using this kind of
> persistent storage, instead of keeping it so that only bootloaders
> (and maybe some userspace code) ever touch it.

Andrew,

What's the next step for this series?  It's one of those areas that
doesn't seem to have clear ownership so this seems to be falling
through the cracks.

Thanks,

Kevin


