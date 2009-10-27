Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZJ0LjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZJ0LjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 07:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZJ0LjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 07:39:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33502 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753382AbZJ0LjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 07:39:05 -0400
Date: Tue, 27 Oct 2009 11:40:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/14] drivers/message: Move dereference after NULL test
Message-ID: <20091027114048.2f79ca46@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0910170833480.9213@ask.diku.dk>
References: <Pine.LNX.4.64.0910170833480.9213@ask.diku.dk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Oct 2009 08:34:18 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test on dev->i2o_dev or i2o_dev is needed, then the dereference
> should be after the NULL test.
> 
> A simplified version of the semantic match that detects this problem is as
> follows (http://coccinelle.lip6.fr/):

Real bug - actually this needs proper locking but I doubt anyone uses I2O
hardware any. Should go in anyway

> Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Alan Cox <alan@linux.intel.com>
