Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbYEDIzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbYEDIzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYEDIzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:55:43 -0400
Received: from 1wt.eu ([62.212.114.60]:4093 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYEDIzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:55:42 -0400
Date: Sun, 4 May 2008 10:55:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080504085514.GA27263@1wt.eu>
References: <20080430000851.GH4818@implementation> <20080430194920.GD7501@1wt.eu> <20080503235027.GO8032@implementation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503235027.GO8032@implementation>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Sun, May 04, 2008 at 12:50:28AM +0100, Samuel Thibault wrote:
> Can you give the patch below a try?
> Dynamic per-VT utf-8 switch should also work, provided that you reopen
> the VT (i.e. log out).

I confirm that your patch works perfectly for me. Now backspace correctly
removes multi-byte characters. My bash is still fooled though but as Alan
explained it, it's readline which has to be upgraded now.

Thanks!
Willy

