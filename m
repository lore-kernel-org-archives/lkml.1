Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYDCKTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYDCKTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYDCKTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:19:17 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:53293 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbYDCKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:19:16 -0400
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: Re: atyfb rmmod & vram crash, 2.6.24, 2.6.25-rc8
Date: Thu, 3 Apr 2008 13:19:05 +0300
Message-Id: <20080403101905.M88395@visp.net.lb>
In-Reply-To: <20080403082336.GD16619@sci.fi>
References: <20080402124854.M56647@visp.net.lb> <20080403082336.GD16619@sci.fi>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 11:23:36 +0300, Ville  wrote
> This region is always 16MB regardless of how much actual RAM is on 
> the card.
Yes, you are right.
There is 4 chips KM4132G512Q10, each 16Mbit, so it is 8192Kbyte.

> The vram paramter takes KB not MB.
> 
> Why do you want to override it anyway? It seems to detect the amount 
> of RAM just fine.
On some settings it was enough, it was my mistake to try set it to higher
value. But in fact it is difficult to find any documentation, that value is in
Kbyte. Probably at least it have to be documented to be visible in modinfo.

> 
> Does this only happen after the failure caused by the bad vram parameter?
Yes, only by bad vram parameter.


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

