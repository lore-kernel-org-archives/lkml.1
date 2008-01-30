Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYA3CJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYA3CJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYA3CI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:08:57 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40612 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbYA3CIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:08:55 -0500
Date: Wed, 30 Jan 2008 03:08:54 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pavel Roskin <proski@gnu.org>
cc: Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
In-Reply-To: <1201657701.24898.14.camel@dv>
Message-ID: <Pine.LNX.4.64.0801300308260.22578@fbirervta.pbzchgretzou.qr>
References: <1201641765.18773.35.camel@dv>  <1201652420.2271.91.camel@perihelion>
 <1201657701.24898.14.camel@dv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29 2008 20:48, Pavel Roskin wrote:
>On Tue, 2008-01-29 at 19:20 -0500, Jon Masters wrote:
>
>> Yes it is. But I thought the existing code was intending to taint the
>> kernel (that's what it does), so it would really help to identify why it
>> tainted the kernel, by calling add_taint_module instead of add_taint. I
>> didn't put the existing match in there...don't shoot the messenger :)
>
>So, it's the same thing as in year 2006.  Good intentions, unexpected
>side effects, and a long discussion.

Perhaps module.c needs more comments explaining why the ndis line
is there, and why it's correct and noone should touch it.
