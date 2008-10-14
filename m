Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYJNBaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYJNBaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYJNBaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:30:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:38214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYJNBaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:30:00 -0400
Message-ID: <48F3F5B4.6040904@kernel.org>
Date: Tue, 14 Oct 2008 10:28:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Christian Trefzer <ctrefzer@gmx.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add =?UTF-8?B?cGF0YV9wZGNfMsOfMjd4IHRvIEtjb25maWcgYW4=?=
 =?UTF-8?B?ZCBNYWtlZmlsZQ==?=
References: <1141054370.3089.0.camel@localhost.localdomain> <20060228003039.GA13335@zeus.uziel.local> <1141120189.3089.47.camel@localhost.localdomain> <20060228102052.GB19574@zeus.uziel.local> <20060228104123.GA13125@zeus.uziel.local>
In-Reply-To: <20060228104123.GA13125@zeus.uziel.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 01:29:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Trefzer wrote:
> It appears to me that some part of drive detection is done twice - at
> least the output is generated redundantly. If this is a bug and not a
> feature, maybe one issue of the output could be trimmed in the end.

That was a long standing bug (or feature in some twisted sense) of
SCSI midlayer.  I think it's gone now.

> There have been rumours about some Promise controller having trouble
> with UDMA6 and the Linux drivers, but I am running this configuration
> for quite some time now and never had the slightest problem.

Looks like you're running quite old kernel.

-- 
tejun
