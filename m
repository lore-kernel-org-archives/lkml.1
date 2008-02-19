Return-Path: <linux-kernel-owner+w=401wt.eu-S1760437AbYBSThm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437AbYBSThm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYBSThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:37:21 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYBSThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:37:20 -0500
Date: Tue, 19 Feb 2008 20:37:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Karl Dahlke <eklhad@comcast.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Where to put adapters
In-Reply-To: <20080119080148.eklhad@comcast.net>
Message-ID: <Pine.LNX.4.64.0802192031350.26109@fbirervta.pbzchgretzou.qr>
References: <20080119080148.eklhad@comcast.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19 2008 08:01, Karl Dahlke wrote:
>
>Now that notifiers are in, (yay!), people are going to start writing adapters
>for visually and motor impaired individuals.
>I suggest we place them in drivers/adapters in the source tree,

Umph, that sounds a bit generic. Network cards are sometimes referred
to as "network [card] adapter" and graphic cards to as "graphics adapter",
so by your suggestions, they would all go into drivers/adapters/.

When such a driver actually comes along, we can revisit the topic.

>and I suggest they put their virtual files in the directory /proc/adapters,
>which would be created via fs/proc/root.c as part of the /proc file system.

Please not. Either character-based devices or sysfs files, depending
on which flies best. Adapters are not really proc-related.
