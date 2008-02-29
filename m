Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbYB2XLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbYB2XLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbYB2XLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:11:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbYB2XLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:11:30 -0500
Date: Sat, 1 Mar 2008 00:11:28 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: linux-kernel@vger.kernel.org
Subject: Re: Few ideas...
In-Reply-To: <m3od9z9y6t.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0803010004350.24056@fbirervta.pbzchgretzou.qr>
References: <m3od9z9y6t.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 29 2008 23:48, Krzysztof Halasa wrote:
>Hi,
>
>There was a thread about MODULE_MAINTAINER but how about a tag which
>a) would be present in source files, not necessarily one per module
>c) would be machine-parseable
>d) would have _no_ effect on object code (i.e., would be ignored by
>   the compiler completely)?

d: I think it would not bad if it were included in the resulting
object file like MODULE_AUTHOR is.
If anything, MODULE_AUTHOR could be removed, because the original
author(s) are usually listed at the top of the .c file and not
always the ones to talk to when there is a bug (=> the maintainer
is).
