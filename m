Return-Path: <linux-kernel-owner+w=401wt.eu-S934190AbYA2UHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190AbYA2UHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYA2UG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:06:59 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYA2UG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:06:57 -0500
Date: Tue, 29 Jan 2008 21:06:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Gerardo Exequiel Pozzi <djgera@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: chars > 0xa0 not displayed in console since 2.6.24
In-Reply-To: <479E5082.50208@gmail.com>
Message-ID: <Pine.LNX.4.64.0801292105370.14907@fbirervta.pbzchgretzou.qr>
References: <479E5082.50208@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2008 20:00, Gerardo Exequiel Pozzi wrote:
>
> Chars are displayed OK in kernels < 2.6.24 (2.6.22.16, 2.6.23.14) with the same
> config.
> I booted clean with init=/bin/bash to discard distro (slackware-current)
> problem/incompat, but the problem persist.
>
> This is a know problem?

Yes, it is a "known" (at least in kernel land, not sure about slack)
"problem" with slackware which does not explicitly set 8-bit mode
during bootup.
