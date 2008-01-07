Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYAGJqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYAGJqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 04:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYAGJqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 04:46:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40580 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYAGJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 04:46:35 -0500
Date: Mon, 7 Jan 2008 07:46:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Gregor Jasny" <gjasny@googlemail.com>
Cc: "Gregor Jasny" <jasny@vidsoft.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vivi driver works only as first device
Message-ID: <20080107074620.3f6bc77a@gaivota>
In-Reply-To: <9d2cd630801061447w33478ad3p4eb24640e7f8784@mail.gmail.com>
References: <20071203225610.GS17496@vidsoft.de>
	<20071206220634.GT17496@vidsoft.de>
	<1197270531.5168.5.camel@gaivota>
	<9d2cd630801061447w33478ad3p4eb24640e7f8784@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 23:47:19 +0100
"Gregor Jasny" <gjasny@googlemail.com> wrote:

> On Dec 10, 2007 8:08 AM, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Thanks for the report. Instead of applying your patch, I decided to
> > better analyze the issue, fixing it with the proper solution. The issue
> > is that vivi_register changes iminor, but this change were not properly
> > returned to the driver.
> 
> Any chance to push this into 2.6.24?

I've scheduled this patch for inclusion at 2.6.25-rc.

Cheers,
Mauro
