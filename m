Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZDGAYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZDGAYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZDGAYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:24:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60819 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZDGAYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:24:38 -0400
Message-ID: <49DA9D41.7020400@pobox.com>
Date: Mon, 06 Apr 2009 20:24:33 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: l.genoni@oltrelinux.com
CC: linux-kernel@vger.kernel.org
Subject: Re: nvida sata controller CK804  and  NCQ not working on linux-2.6.28||29.1
References: <Pine.LNX.4.64.0904061458540.3110@Phoenix.oltrelinux.com>
In-Reply-To: <Pine.LNX.4.64.0904061458540.3110@Phoenix.oltrelinux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

l.genoni@oltrelinux.com wrote:
> 
> Hi,
> to make NCQ work with nvidia sata CK804 I had to introduce this simple 
> change into sata-nv.c. Is there some reason I am missing why adma_enable 
> is not by default one, so later in the dome NCQ is not enabled?

Yes -- too many problems in the field led us to disable ADMA by default.

	Jeff




