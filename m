Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYEKS4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYEKS4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbYEKS4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:56:39 -0400
Received: from mail.aknet.ru ([78.158.192.26]:58914 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbYEKS4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:56:39 -0400
Message-ID: <4827415A.7060101@aknet.ru>
Date: Sun, 11 May 2008 22:56:26 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it>
In-Reply-To: <482737BE.20502@infracom.it>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Roberto Oppedisano wrote:
> artsd (kde sound daemon) is broken on current git for my system.
> 
> git-bisect reveals the following patch as the culprit:
> 
> commit e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
> Author: Stas Sergeev <stsp@aknet.ru>
> Date:   Wed May 7 12:39:56 2008 +0200
> 
>     pcspkr: fix dependancies
[]
> More info on request.
cat /proc/asound/cards
I guess you simply got the pc-speaker driver
loaded first and became your primary sound
driver, which is not what you want.
