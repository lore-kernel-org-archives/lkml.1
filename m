Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbYA1QLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbYA1QLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYA1QLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:11:09 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51614 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYA1QLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:11:08 -0500
Date: Mon, 28 Jan 2008 17:11:06 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roy Zacharias <royprogram@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: telnet hanging issues in kernel 2.6.16
In-Reply-To: <eca31190801280802m6e5b2c4bna4cc567e9935b30c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801281709350.1185@fbirervta.pbzchgretzou.qr>
References: <eca31190801280802m6e5b2c4bna4cc567e9935b30c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 28 2008 10:02, Roy Zacharias wrote:
>Hello,
>
>This is my first time posting on this list.  Currently, I am working
>on a powerpc board and I encounter some problems.  When I do the
>following:
>
>1. Login to my card from pc as root
>2. Run command (i.e. ls, ps, etc.)
>3. Wait 30 min-1hr
>4. Run command
>
>After the fourth step, I only see the partial output of the command
>and my telnet session becomes unresponsive and I have to connect
>again.

Hm, could it be an MTU/MSS/SACK/Window Sizing issue?
When you see the partial output, the window is enlarged because of the bulk
output you get from the command.
