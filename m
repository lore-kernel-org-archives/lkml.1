Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZIIVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZIIVXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZIIVXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:23:22 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:50125 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZIIVXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <87my53vo6d.fsf@depni.sinp.msu.ru>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru>
	 <873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu>
	 <87my53vo6d.fsf@depni.sinp.msu.ru>
Date: Wed, 9 Sep 2009 17:23:24 -0400
X-Google-Sender-Auth: 855e617b92da87b9
Message-ID: <50fc5f090909091423s2a7e652em2fa4cc80b41a6f74@mail.gmail.com>
Subject: Re: Epic regression in throughput since v2.6.23
From: Cory Fields <TheUni@xbmc.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed the same regression since around 2.6.23, mainly in
multi-core video decoding. A git bisect reveals the guilty commit to
be: 33b0c4217dcd67b788318c3192a2912b530e4eef

It is easily visible because with the guilty commit included, one core
of the cpu remains pegged while the other(s) are severly
underutilized.

Hope this helps

Cory Fields
