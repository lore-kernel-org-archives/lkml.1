Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXEFWxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXEFWxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXEFWxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:53:54 -0400
Received: from hera.cwi.nl ([192.16.191.8]:49563 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXEFWxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:53:53 -0400
Date: Mon, 7 May 2007 00:53:38 +0200
From: Andries Brouwer <Andries.Brouwer@cwi.nl>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: bzolnier@gmail.com, michal.kepien@poczta.onet.pl,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pata-2.6 fix queue] hpt366: don't check enablebits for HPT36x
Message-ID: <20070506225338.GA28300@apps.cwi.nl>
References: <200705042318.37367.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705042318.37367.sshtylyov@ru.mvista.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 11:18:37PM +0400, Sergei Shtylyov wrote:
> HPT36x chip don't seem to have the channel enable bits,
> so prevent the IDE core from checking them...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Earlier this evening I reported that HPT366 was broken in 2.6.21.
I confirm that this fixes it for me.

Andries
