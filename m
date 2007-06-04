Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbXFDMKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbXFDMKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbXFDMKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:10:35 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:49854 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbXFDMKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:10:35 -0400
Date: Mon, 4 Jun 2007 15:10:33 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@stusta.de>, Matti Aarnio <matti.aarnio@zmailer.org>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-kernel@vger.kernel.org
Subject: Re: gmail is a bit too popular..
Message-ID: <20070604121033.GY20047@mea-ext.zmailer.org>
References: <20070507145555.GG3883@mea-ext.zmailer.org> <alpine.DEB.0.98.0705071101510.6512@sigma.j-a-k-j.com> <20070507153511.GH3883@mea-ext.zmailer.org> <20070508064316.GF4226@stusta.de> <1180954532.25232.252.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180954532.25232.252.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:55:32AM +0100, David Woodhouse wrote:
> On Tue, 2007-05-08 at 08:43 +0200, Adrian Bunk wrote:
> > BTW (not related to gmail):
> > Are there any news regarding the buggy 451 handling in zmailer I'm 
> > reporting again and again that regularly results in every single 
> > linux-kernel message sent to me being delayed by up to 13 hours? 
> 
> Er, you're giving it a 451 response to _every_ message? Why?

His secondary MX server:

   220 mailrelay1.lrz-muenchen.de (IntraStore TurboSendmail) ESMTP Service ready

yields at times "451-responses".  (It suffers from occasional resource starvations
and only way to get out of it is to temporarily give those replies.)


Indeed there was queue timer bug at VGER in case remote replied with
TEMPFAILs sufficiently many times, the whole destination queue to it
got kicked back way too much.

> -- 
> dwmw2

/Matti Aarnio
