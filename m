Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbYCFLW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbYCFLW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbYCFLWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:22:19 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:41145 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756971AbYCFLWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:22:18 -0500
X-YMail-OSG: APn3s_EVM1mAo9radL1MVXEQgWCR0ac8mTDjuGV.uvSNVoeGB0Hn9OvVPmWxNSq24nMXDjnZQw--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 6 Mar 2008 03:22:12 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pawel Plociennik <paplociennik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Message-ID: <20080306112212.GA9261@puku.stupidest.org>
References: <200803060001.38432.paplociennik@gmail.com> <20080306103422.GA5511@puku.stupidest.org> <20080306104448.GG13391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306104448.GG13391@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:44:48AM +0100, Ingo Molnar wrote:

> we can/could do many other boot options via an initrd too.

There has been some talk of this and even an implementation of much of
it.  I'm not convinced it's a bad idea, I've had to use it myself on
products where the in-kernel ip auto-configuration doesn't work.

> But given an existing initrd (which might have come from the distro,
> etc.) i prefer adding boot options instead of modifying the initrd.

I assume this is so you have have /distro1 /distro2 and use your boot
option to (help) select which one you boot into?
