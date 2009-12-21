Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZLUTb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZLUTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 14:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZLUTbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 14:31:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbZLUTbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 14:31:24 -0500
Message-ID: <4B2FCCE3.1090209@redhat.com>
Date: Mon, 21 Dec 2009 11:30:43 -0800
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk>
In-Reply-To: <20091217181718.GA4440@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 10:17 AM, Russell King - ARM Linux wrote:
> How is "size-optimal trap" defined?

E.g. Sparc and MIPS have "tcc" instructions that trap based on the
condition codes, and so we eliminate the branch.  That's the only
optimization we apply with __builtin_trap.

> Let me put it another way: I want this function to terminate with an
> explicit NULL pointer dereference in every case.

Then just use that.


r~
