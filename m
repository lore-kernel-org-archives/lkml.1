Return-Path: <linux-kernel-owner+w=401wt.eu-S935364AbZLGQ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364AbZLGQ06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934861AbZLGQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:26:57 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:34558 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933781AbZLGQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:26:56 -0500
Message-ID: <4B1D2C80.4060202@oracle.com>
Date: Mon, 07 Dec 2009 08:25:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: input tree build failure
References: <20091207200344.01323cb5.sfr@canb.auug.org.au>
In-Reply-To: <20091207200344.01323cb5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B1D2CCF.00A1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/input/sparse-keymap.c:101: error: __ksymtab_sparse_keymap_setkeycode causes a section type conflict
> 
> Caused by commit a2dd9f7ceeb28f495587834aa5778c721611d61b ("Input: add
> generic support for sparse keymaps").
> 
> static functions should not given to EXPORT_SYMBOL().
> 
> I have reverted that commit for today.

(DT:) Is that what causes wistron_btns builds to fail also?

-- 
~Randy
