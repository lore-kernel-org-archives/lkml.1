Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZLCEn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZLCEn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 23:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZLCEn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 23:43:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:44662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZLCEn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 23:43:58 -0500
Date: Wed, 2 Dec 2009 20:46:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug (minor): microcode_intel.c applies updates to hyperthreaded
 cores
Message-ID: <20091202204609.555313d6@infradead.org>
In-Reply-To: <4B173FE0.7030302@majjas.com>
References: <4B17393B.7000304@majjas.com>
	<20091202202012.0c7b6768@infradead.org>
	<4B173FE0.7030302@majjas.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Dec 2009 23:34:40 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> Fair point - guess it's a different bug. Looks like the mechanism
> sets up the requests first for all cpus, then loads them.
> apply_microcode doesn't recheck.
> 

ok that's likely the real bug ...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
