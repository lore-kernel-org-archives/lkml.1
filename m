Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYLKXlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYLKXlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbYLKXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:41:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219AbYLKXlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:41:22 -0500
Message-ID: <4941A517.2010704@zytor.com>
Date: Thu, 11 Dec 2008 15:41:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "J.A. Magallon" <magallon@unizar.es>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Is there something like multi-device fan out ?
References: <20081212000452.0ff5dfd9@werewolf.home>
In-Reply-To: <20081212000452.0ff5dfd9@werewolf.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallon wrote:
> Hi...
> 
> I suspect this sounds like a strange question.
> A friend has a company that distributes his own catalogs on CD-ROM, and wants
> to build a mass-burning box (something like 8 CD/DVD burners), running linux.
> 
> The problem is how to burn an image at the same time to all writers.
> I could write a script, but I think this would launch 8 reads on the same
> iso file, all desynchronized, that will drive nuts the disk.

Not really.  They will end up synchronized through a mechanism called
the cache capture effect: the image that is behind will have the benefit
of having the precursors already having read the input, so it's ready
for use in the cache already, therefore it will run faster.  The stable
condition, as long as the writers are close to the same speed and the
writes are started at close enough to the the same time, is that they
are all writing the same data at almost the same time.

	-hpa


