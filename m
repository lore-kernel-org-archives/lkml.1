Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbZBMSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbZBMSwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZBMSwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:52:11 -0500
Received: from gw.goop.org ([64.81.55.164]:59919 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZBMSwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:52:10 -0500
Message-ID: <4995C157.9020102@goop.org>
Date: Fri, 13 Feb 2009 10:52:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: include linux/types.h
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu> <20090213122325.GA30061@elte.hu>
In-Reply-To: <20090213122325.GA30061@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> From 56cefcea7c8769ffc04a5609e6ac849e36685468 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 13 Feb 2009 13:23:02 +0100
> Subject: [PATCH] x86 headers: include linux/types.h
>
> To properly pick up types relied on by prototypes like 'bool'.
>   

linux/types.h is not assembler-safe.

    J
