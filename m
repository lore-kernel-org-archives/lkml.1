Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbXG2NEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbXG2NEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762154AbXG2NED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:04:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761975AbXG2NEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:04:01 -0400
Message-ID: <46AC900E.9090405@redhat.com>
Date: Sun, 29 Jul 2007 21:03:10 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of
 core_pattern enhancements
References: <20070727200050.GA18946@hmsreliant.homelinux.net> <46AC6EAB.7000502@redhat.com> <20070729121444.GA9644@hmsreliant.homelinux.net>
In-Reply-To: <20070729121444.GA9644@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Sun, Jul 29, 2007 at 06:40:43PM +0800, Eugene Teo wrote:
>> Neil Horman wrote:
[...]
>> You may want to improve your patches with style-related changes, including
>> removing trailing spaces, using tabs instead of spaces, and defining pointers
>> like char *ptr instead of char * ptr.
>>
> I assume this is just a general comment, since as far as I can see, I've
> followed those guidelines.

Please see the next few emails.

>> Also, it is probably good to think how we can "drop privileges" while piping
>> the core dump output to an external program. A malicious user can potentially
>> use it as a possible backdoor since anything that is executed by "|program" will
>> be executed with root privileges.
>>
> It was my understanding that apport already did this.

I haven't looked at apport yet, but are you talking about the userspace portion of
apport or the kernel changes in the Ubuntu kernel?

Eugene
