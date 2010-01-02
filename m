Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109Ab0ABMhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0ABMhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 07:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318Ab0ABMhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 07:37:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:35642 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0ABMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 07:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sXIt/lJPj9B5gDj55pe5GXXcQiZ2PPskzJAtrxMj9uLmNQX+w56md/T7TC6g+RSc4j
         947UDgH1AVTg0Z+yBFKySsigcMrTVNWEsbh6bWuOQY/gdEmyNkR12tWpeba6QnqtEoLy
         J1pZ9kIrzozeW8fapFDGve7AKmYlpFC5bH6pc=
Message-ID: <4B3F3DE7.7030809@googlemail.com>
Date: Sat, 02 Jan 2010 13:36:55 +0100
From: Daniel Borkmann <llug.dan@googlemail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace notification from module
References: <4b387f18.307edfdc.4b3f399c.3bc2e@o2.pl>
In-Reply-To: <4b387f18.307edfdc.4b3f399c.3bc2e@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartłomiej,

Bartłomiej Zimoń wrote:
> Use inotify from userspace could be interesting for such data,
> but looks like sysfs/procfs doesn't send signal about data changed in file or maybe i'm wrong?
> 
> If sysfs/procfs is wrong for that so must create device file, but here secound problem 
> how to notify that file/buffer has new data?

Actually, the file content of a procfs file is volatile and generated on
the fly, just have a look at some device drivers or at the API.

Did you have a look at the netlink protocol for communication from
kernel to userspace?

Cheers,
Daniel
