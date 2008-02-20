Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYBTKf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYBTKf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYBTKfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:35:51 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39289 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYBTKfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:35:50 -0500
Date: Wed, 20 Feb 2008 11:35:49 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>, linux-kernel@vger.kernel.org
Subject: Re: vfat32 Free Cluster Count Update
In-Reply-To: <877ih1w8hb.fsf@duaron.myhome.or.jp>
Message-ID: <Pine.LNX.4.64.0802201135150.26109@fbirervta.pbzchgretzou.qr>
References: <fp77bc$akv$1@ger.gmane.org> <877ih1w8hb.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19 2008 19:23, OGAWA Hirofumi wrote:
>
>This problem was introduced by it ignores a free cluster count (not
>"usefree"). If we was not using "usefree" option, FAT doesn't trust the
>"free cluster count" anymore.
>
>So, it doesn't update until re-count.  Um.. yes, it's a bit
>problem. Ah.. it can fix "we can trust now"-flag or something.
>
>I'll dig it more, later. And for right now, please run "df" command, it
>will fix free cluster count.
>
Ah, _that's_ why the first invocation `df` command after a fresh boot
always takes so long!
