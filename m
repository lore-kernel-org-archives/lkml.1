Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbYBTSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbYBTSCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYBTSC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:02:29 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:40786 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYBTSC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HnvTsKCrT5t51erl1w2x5aig3/o5D82nSraggeZ5yCB1+H7sID3PrIozKekCWEx0RQq5XPlq+kO+6IgyNpKB+UhQu9hbk+5T3ADCFuytLw8dnTW+AO+8+vTCdpBELz7RaBX0YUV3Ix+qmvn94/ep/cuN/b4BOlBUu7vuheLBMsk=
Message-ID: <b6a2187b0802201002t315548b5uac623759723842d0@mail.gmail.com>
Date: Thu, 21 Feb 2008 02:02:25 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Jesse Barnes" <jesse.barnes@intel.com>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <alpine.LFD.1.00.0802200945591.7833@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <alpine.LFD.1.00.0802200922590.7833@woody.linux-foundation.org>
	 <b6a2187b0802200937q3ff8f470k235b5d1e00eab59e@mail.gmail.com>
	 <alpine.LFD.1.00.0802200945591.7833@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 21, 2008 1:52 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ahh. You're using the BIOS to re-initialize your video, aren't you?

I don't know. Just pure simple "s2ram" without any options.


> Let's try to narrow it down to what the interaction is. Are you using
> something like acpi_sleep=s3_bios or similar?

No. Not additional command line option except for resume=/dev/sda3 reboot=bios


> That's what the kernel support is supposed to make unnecessary in the long run,

Ok, understand now.

Jeff.
