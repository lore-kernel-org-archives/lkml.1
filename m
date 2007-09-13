Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbXIMRJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbXIMRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbXIMRJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:09:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXIMRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:09:20 -0400
Message-ID: <46E96EB0.7060507@zytor.com>
Date: Thu, 13 Sep 2007 10:09:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
References: <46E81AC6.3000306@googlemail.com>
In-Reply-To: <46E81AC6.3000306@googlemail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> 
> Subject         : console is messed up after resume from s2ram or switching to console from X
> References      : http://lkml.org/lkml/2007/8/4/6
> Last known good : ?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Caused-By       : ?
> Handled-By      : H. Peter Anvin <hpa@zytor.com>
>                   Antonino A. Daplas <adaplas@gmail.com>
> Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
> Status          : problem is being debugged
> 

Finally diagnosed.  A patch should be coming shortly.

	-hpa
