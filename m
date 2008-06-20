Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbYFTUvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbYFTUvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYFTUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:51:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34639 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYFTUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:51:44 -0400
Message-ID: <485C149E.1000807@kernel.org>
Date: Fri, 20 Jun 2008 13:35:42 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Introduce userspace interface for Firmware-provided memory map
References: <1213977420-1555-1-git-send-email-bwalle@suse.de> <20080620194200.GC21235@redhat.com>
In-Reply-To: <20080620194200.GC21235@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Jun 20, 2008 at 05:56:57PM +0200, Bernhard Walle wrote:
>> This patch (as request for comments) introduces a new userspace interface
>> /proc/firmware_mem that provides the unfiltered view of the BIOS on
>> memory configuration. That's usable for two reasons:
> 
> How about /proc/firmware_memmap. This is little longish but probably more
> clear in intent.

Perhaps even /proc/firmware/memmap (or /sys/firmware/memmap/...).  I 
realize introducing a new directory is annoying, but it's a namespace 
that is likely to have other users.

	-hpa
