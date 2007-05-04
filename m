Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXEDHRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXEDHRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXEDHRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:17:23 -0400
Received: from smtp.nokia.com ([131.228.20.171]:46626 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbXEDHRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:17:22 -0400
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Florin Malita <fmalita@gmail.com>
Cc: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <463A04A5.5030103@gmail.com>
References: <463A04A5.5030103@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 04 May 2007 10:17:10 +0300
Message-Id: <1178263030.3659.15.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 May 2007 07:17:10.0492 (UTC) FILETIME=[3B16B1C0:01C78E1C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 11:49 -0400, Florin Malita wrote:
> Coverity (CID 1614) spotted new_seb being dereferenced after kfree() in 
> create_vtbl's write_error path.

Applied with minor trailing white-space cleanup, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

