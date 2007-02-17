Return-Path: <linux-kernel-owner+w=401wt.eu-S1946489AbXBQIc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946489AbXBQIc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946502AbXBQIc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:32:59 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:52199 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946489AbXBQIc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:32:58 -0500
Date: Sat, 17 Feb 2007 09:33:13 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@osdl.org>, Mauro Carvalho Chehab <mchehab@linuxtv.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix SAA7146_CLIPPING_MEM size
Message-ID: <20070217083313.GA14918@aepfle.de>
References: <20070216231425.GA11836@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070216231425.GA11836@aepfle.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, Olaf Hering wrote:

> So a max array size of 131329 is enough.

Since the referenced array is u32, should it be 4 * 131329?
