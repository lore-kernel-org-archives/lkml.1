Return-Path: <linux-kernel-owner+w=401wt.eu-S967526AbXEHAVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967526AbXEHAVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967493AbXEHAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:21:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967475AbXEHAVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:21:34 -0400
Message-ID: <463FC1F7.7090806@redhat.com>
Date: Mon, 07 May 2007 20:19:03 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Kristian H??gsberg <krh@redhat.com>,
       John Stoffel <john@stoffel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 3/6] firewire: char device interface
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <17976.44988.734513.121919@smtp.charter.net> <4638FE91.6050001@redhat.com> <20070504094817.GA31811@infradead.org>
In-Reply-To: <20070504094817.GA31811@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 02, 2007 at 05:11:45PM -0400, Kristian H??gsberg wrote:
>> The firewire-cdev.h file is meant to be a self-contained userspace header 
>> file and shouldn't include other kernel header files.  All duplicated 
>> values are standardized ieee1394 values and won't ever change.  I should 
>> put a #ifndef __FW_COMMON_DEFINES protection around the duplicate values, I 
>> guess, but I'm just wondering why I never saw a "symbol redefined" 
>> warning...
> 
> No, defining things in two places is not okay.  Just add a new header
> that defines these protocol constants, which needs to be included by
> userspace that wants to use them.

Ok, I split out the shared constants into linux/firewire-constants.h which 
gets included by linux/firewire-cdev.h.

Kristian

