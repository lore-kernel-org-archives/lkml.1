Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbXA2LfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbXA2LfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXA2LfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:35:03 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:52292 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbXA2LfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:35:01 -0500
Date: Mon, 29 Jan 2007 12:34:58 +0100 (MET)
From: Oliver Neukum <oliver@neukum.name>
To: nigel@nigel.suspend2.net
Subject: Re: question on resume()
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200701291206.39637.oneukum@suse.de>
 <1170069896.3538.26.camel@nigel.suspend2.net>
In-Reply-To: <1170069896.3538.26.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291234.59706.oliver@neukum.name>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Januar 2007 12:24 schrieb Nigel Cunningham:
> Hi.
> 
> On Mon, 2007-01-29 at 12:06 +0100, Oliver Neukum wrote:
> > Hi,
> > 
> > may a driver call wake_up() while doing resume() ?
> 
> I assume you mean waking a userspace process from drivers_resume(). If
> so, the answer is no - processes will still be frozen at the point. In
> the case of Suspend2, the LRU pages will still not have been read
> either, so Suspend2 users would hate you for making hibernation crash
> and burn :)

If so, how do I notify tasks presumably about to be thawed that their
IO failed?

	Regards
		Oliver
