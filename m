Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYLLWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYLLWOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 17:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYLLWOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 17:14:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbYLLWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 17:14:23 -0500
Message-ID: <4942E234.4070203@zytor.com>
Date: Fri, 12 Dec 2008 14:14:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: "J.A. Magallon" <magallon@unizar.es>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Is there something like multi-device fan out ?
References: <20081212000452.0ff5dfd9@werewolf.home> <4941A517.2010704@zytor.com> <20081212115311.GA15948@citd.de>
In-Reply-To: <20081212115311.GA15948@citd.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schniedermeyer wrote:
> 
> And if you want to be absolutly sure.
> 
> RAM is cheap nowadays, plug in enough RAM (no swap!) so you can copy the 
> image to burn into a tmpfs before starting to write them.
> No disc IO involved at all. ;-)
> 

You don't have to copy it to tmpfs, either.  Just let the cache do its job.

	-hpa
