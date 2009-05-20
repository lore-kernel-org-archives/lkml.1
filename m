Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZETLRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZETLRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZETLQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:16:56 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38263 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZETLQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:16:55 -0400
Date: Wed, 20 May 2009 20:16:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andr? Lopes <andre.neo.net@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Are the cast necessary in function "kfree"?
Message-ID: <20090520111650.GA11557@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andr? Lopes <andre.neo.net@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5c43c2d40905200330p5b14be2ey567bc493374e09b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c43c2d40905200330p5b14be2ey567bc493374e09b3@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 11:30:21AM +0100, Andr? Lopes wrote:
> Hi. This is my first post :-)
> 
> I was reading this doc (/linux-2.6/Documentation/scsi/ChangeLog.lpfc),
> when I found this phrase: "Replace some kfree((void*)ptr) with
> kfree(ptr)."
> 
[snip]

> These casts are not necessary...I think so. If it's yes, can we apply
> patch's to clean-up this?
> 
The key thing here is "ptr", as long as these are pointers, then the cast
is superfluous. In the case of casting from a non-pointer type, the cast
is necessary, particularly if the data type and pointer size vary.
