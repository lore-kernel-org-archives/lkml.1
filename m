Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbYETSbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbYETSbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbYETSb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:31:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46055 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYETSb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:31:28 -0400
Message-ID: <483318FD.5040506@firstfloor.org>
Date: Tue, 20 May 2008 20:31:25 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <27468.1211299125@vena.lwn.net>
In-Reply-To: <27468.1211299125@vena.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> I guess my one concern with this mirrors what other people have said:
> might not it be better to just push the BKL down into the fasync()
> implementations and avoid adding yet another file operation?  A quick
> grep shows 43 drivers defining fasync() functions - and many of those
> use the same one.  fs/ has a few more.  Obnoxious but doable, unless
> there's something I'm missing?

See my reply to Arjan.  While for complicated stuff pushing down first
is better, fasync is not that complicated and I think my strategy
with the new entry point, with the old one going away is better in this
case.

-Andi

