Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZFBI3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZFBI3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbZFBI2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:28:50 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:56638 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbZFBI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fjWQMN3SisXmDP6bVjV7qiQ8VWVyWoJUtPSuOSbIGQQP3rWT6KEaLDvyN5n+O6E1SR
         rpGlBxKgdW/xkLJMqBIbJwOckaLcFg47ScpSEVOplPbLD+0ckThpfsi68xDwp3S9Zqcj
         SGTyGy8n8KcZ2BUIAaT5gRSXUF6cOhLwI1wBw=
MIME-Version: 1.0
In-Reply-To: <87my8rcbp7.fsf@basil.nowhere.org>
References: <3877989d0906010201j438a08a8x559f62b0aed40696@mail.gmail.com>
	 <87my8rcbp7.fsf@basil.nowhere.org>
Date: Tue, 2 Jun 2009 16:28:49 +0800
Message-ID: <3877989d0906020128g7f82dfc0l47dcaa9a98460111@mail.gmail.com>
Subject: Re: [RFC patch] reset TSC at the begining of check_tsc_warp
From: Luming Yu <luming.yu@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So you're hurting the good systems for one buggy box. I don't think
> that's a good idea.

Yes, the patch should be polished to avoid already-perfect-synced-tsc
case...the whole point of this patch is trying to improve , not damage...
Although I'm not quite sure how much diff the patch could
introduce...,given execution of
the function has already synced between CPUs....But this should be
another topic..
