Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbYIKTgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbYIKTgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYIKTgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:36:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYIKTgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:36:35 -0400
Message-ID: <48C97338.5080502@zytor.com>
Date: Thu, 11 Sep 2008 12:36:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Harun Scheutzow <harun04@scheutzow.de>, linux-kernel@vger.kernel.org
Subject: Re: vfat file system extreme fragmentation on multiprocessor
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de> <20080911191049.GB31271@csclub.uwaterloo.ca>
In-Reply-To: <20080911191049.GB31271@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> 
> I don't think fat filesystems have any concept of reserving space for
> expanding files.  It's a pretty simple filesystem after all designed for
> a single cpu machine with a non-multitasking OS (if you can call DOS an
> OS).  Space tends to be allocated from the start of the disk wherever
> free space is found since otherwise you would have to go searching for
> the free space, which isn't that efficient.
> 

Well, you can always do that in-memory.

	-hpa

