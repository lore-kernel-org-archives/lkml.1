Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab0CCUHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:07:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab0CCUHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:07:31 -0500
Message-ID: <4B8EC173.6010300@zytor.com>
Date: Wed, 03 Mar 2010 12:07:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] init: Open /dev/console from rootfs
References: <m1sk8hn8nk.fsf@fess.ebiederm.org> <20100303195716.GT30031@ZenIV.linux.org.uk>
In-Reply-To: <20100303195716.GT30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 11:57 AM, Al Viro wrote:
> On Tue, Mar 02, 2010 at 11:53:19PM -0800, Eric W. Biederman wrote:
>>
>> To avoid potential problems with an empty /dev open /dev/console
>> from rootfs instead of waiting to mount our root filesystem and
>> mounting it there.   This effectively guarantees that there will
>> be a device node, and it won't be on a filesystem that we will
>> ever unmount, so there are no issues with leaving /dev/console
>> open and pinning the filesystem.
>>
>> This is actually more effective than automatically mounting
>> devtmpfs on /dev because it removes removes the occasionally
>> problematic assumption that /dev/console exists from the boot
>> code.
> 
> Hell, yeah.  Applied, with thanks.

:) :)

	-hpa

