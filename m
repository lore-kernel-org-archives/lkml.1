Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYKONJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYKONJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYKONJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:09:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51517 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbYKONJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:09:02 -0500
To: "Karl Pickett" <karl.pickett@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: tcp_tw_recycle broken?
From: Andi Kleen <andi@firstfloor.org>
References: <f9be06770811142037v794cf4f8w7a82ab45c0f3820c@mail.gmail.com>
	<20081115055748.GY24654@1wt.eu>
	<f9be06770811142329x7d6dcb89vd573962970d503b3@mail.gmail.com>
Date: Sat, 15 Nov 2008 14:09:04 +0100
In-Reply-To: <f9be06770811142329x7d6dcb89vd573962970d503b3@mail.gmail.com> (Karl Pickett's message of "Sat, 15 Nov 2008 02:29:27 -0500")
Message-ID: <874p2916hb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Karl Pickett" <karl.pickett@gmail.com> writes:
>
> May I just confirm.. is tcp_tw_reuse NOT dependent on receiving timestamps?

The big problem is that both are incompatible with NAT. So if you
ever talk to any NATed clients don't use it.

-Andi

-- 
ak@linux.intel.com
