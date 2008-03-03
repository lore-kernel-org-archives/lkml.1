Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYCCPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYCCPLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbYCCPK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:10:59 -0500
Received: from lazybastard.de ([212.112.238.170]:60098 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYCCPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:10:58 -0500
Date: Mon, 3 Mar 2008 16:10:12 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alexander Belyakov <abelyako@googlemail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: jffs2: -ENOSPC when truncating file?!
Message-ID: <20080303151012.GB17732@lazybastard.org>
References: <20080223235742.GE2202@elf.ucw.cz> <fe810cf0802242348w625a7e7bj1a5476d6c79662@mail.gmail.com> <20080303121510.GD28369@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080303121510.GD28369@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 March 2008 13:15:11 +0100, Pavel Machek wrote:
> 
> Patch is here (I whitespace-damaged it, sorry], and I've seen no
> discussion.. should it just be applied?

There was discussion.  The patch is a pure band-aid.  It should not make
a difference at all, so clearly something is very wrong and we should
dig deeper to find the real problem.  So far noone has done it.

Jörn

-- 
All models are wrong. Some models are useful.
-- George Box
