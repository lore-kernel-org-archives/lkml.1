Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZCIPee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZCIPee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZCIPe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:34:26 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57730 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbZCIPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:34:25 -0400
Message-ID: <49B536F4.9060609@freescale.com>
Date: Mon, 09 Mar 2009 10:34:12 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com
Subject: Re: [PATCH v2] add function spin_event_timeout()
References: <1236611904-9843-1-git-send-email-timur@freescale.com> <87a5b0800903090831l6a74b8afhd640ce880be36114@mail.gmail.com>
In-Reply-To: <87a5b0800903090831l6a74b8afhd640ce880be36114@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:

> Are you sure you want to evaluate condition a second time when
> returning? Some memory mapped registers don't have a stable value so
> e.g. the first test could succeed but the return value could still be
> zero.

Ah, good point.  I was hoping to keep the loop simple by combining the
two test conditions, but I guess that's not going to work.

v3 coming up.

-- 
Timur Tabi
Linux kernel developer at Freescale
