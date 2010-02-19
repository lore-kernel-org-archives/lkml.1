Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0BSVoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:44:54 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:35078 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0BSVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:44:52 -0500
From: James Cloos <cloos@jhcloos.com>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
In-Reply-To: <93cdabd21002191322g7ea13d8bk52f1545df913f07@mail.gmail.com>
	(Mike Fedyk's message of "Fri, 19 Feb 2010 13:22:45 -0800")
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<93cdabd21002191322g7ea13d8bk52f1545df913f07@mail.gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 19 Feb 2010 16:44:08 -0500
Message-ID: <m3r5ognbnj.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Fedyk <mfedyk@mikefedyk.com> writes:

Mike> On Sat, Feb 13, 2010 at 7:11 PM, James Cloos <cloos@jhcloos.com> wrote:
>> Sometime between rc6 and rc7 all filesystem I/O started using 100% CPU,
>> usually on the order of 60% sys, 40% user.
>> 
>> I've tried this with each of ext4, jfs and btrfs filesystems.  All show
>> the same issue.
>> 

Mike> Are you sure you're not running with any of the debugging options
Mike> enabled?  I see the same, but I have debugging enabled (rawhide
Mike> kernel).

There are some:

CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_USB_SERIAL_DEBUG=m
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y

I forgot about /proc/sched_debug, but am back at -rc6 right now; I'll
post an example of /proc/sched_debug output during the issue when I'm
next in rc8 or later.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
