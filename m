Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYCVJHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYCVJHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 05:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYCVJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 05:07:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52316 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYCVJHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 05:07:12 -0400
Date: Sat, 22 Mar 2008 10:10:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080322091001.GA7264@one.firstfloor.org>
References: <20080318104437.966c10ec.akpm@linux-foundation.org> <20080319083228.GM11966@one.firstfloor.org> <20080319020440.80379d50.akpm@linux-foundation.org> <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com> <20080320090005.GA25734@one.firstfloor.org> <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com> <20080321172644.GG2346@one.firstfloor.org> <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com> <20080322071755.GP2346@one.firstfloor.org> <1206170695.2438.39.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206170695.2438.39.camel@entropy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not stick the bitmap in an xattr?

xattrs are too small for potentially large binaries and a mess to manage 
(a lot of tools don't know about them)

-Andi
