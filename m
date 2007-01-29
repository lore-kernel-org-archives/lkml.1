Return-Path: <linux-kernel-owner+w=401wt.eu-S933035AbXA2BS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbXA2BS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 20:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbXA2BS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 20:18:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56070 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035AbXA2BS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 20:18:56 -0500
Subject: Re: [PATCH 1/2] Define the EF_AS_NO_RANDOM e_flag bit
From: Arjan van de Ven <arjan@infradead.org>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Valdis.Kletnieks@vt.edu, David Wagner <daw@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <877ivd8p42.wl@betelheise.deep.net>
References: <87r6toufpp.wl@betelheise.deep.net>
	 <200701221520.l0MFKLdK032645@turing-police.cc.vt.edu>
	 <871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz>
	 <87mz4996wg.wl@betelheise.deep.net>
	 <20070123154127.57059632@localhost.localdomain>
	 <877ivd8p42.wl@betelheise.deep.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 29 Jan 2007 09:18:12 +0800
Message-Id: <1170033494.3054.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 23:28 +0300, Samium Gromoff wrote:
> Author: Samium Gromoff <deepfire@betelheise.deep.net>
> Date:   Tue Jan 23 22:31:13 2007 +0300
> 
>     Define the ELF binary header flag EF_AS_NO_RANDOM
>     
>     EF_AS_NO_RANDOM should mean that the binary requests to not apply
>     randomisation to address spaces of its processes.

sounds like it's not the right approach; better to follow the
PT_GNU_STACK example and do it that way.....

(assuming you even need it... I personally consider every binary that
would need this flag as broken)

