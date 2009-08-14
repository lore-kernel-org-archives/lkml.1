Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZHNSq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZHNSq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbZHNSqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:46:55 -0400
Received: from mail2.shareable.org ([80.68.89.115]:40128 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbZHNSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:46:51 -0400
Date: Fri, 14 Aug 2009 19:46:51 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090814184651.GA12021@shareable.org>
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A85AAC4.7050505@acm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx wrote:
> Or maybe its cheap and slow flash. In that case I think your only hope 
> is to make all the code as small as possible and/or find a different 
> flash filesystem that does not have to read so much of the device to 
> mount. Perhaps use a read-only compressed filesystem for the system 
> binaries and reflash it for software upgrades. Only init and mount the 
> writable flash for user-storable data well after system boot has finished.

Fwiw, logfs claims to mount quickly, but I haven't heard much about it
in recent months and http://logfs.org/logfs/ implies it's not really
stable yet.  But maybe if you're working on a prototype that doesn't
matter so much.

-- Jamie
