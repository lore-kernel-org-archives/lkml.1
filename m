Return-Path: <linux-kernel-owner+w=401wt.eu-S1031704AbXEANdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031704AbXEANdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031710AbXEANdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:33:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:37621 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031705AbXEANdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KGk3oUBNrZ1/upUPVMJ9H69lRgqVGP/R70I34otclE3f3fxJDd6Y4m1kA0d8z77GCBXu9hen0P5gvVYzflZgUQzEgwDrfG12NhdlAC/deXsK0ZEuEw7K8vO/O13iws2AXPdSf/UB+LCpeySgI7CVgQFSjRCKsdoCTmnOwPnpqOE=
Message-ID: <46374161.3020801@gmail.com>
Date: Tue, 01 May 2007 15:32:17 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: William Thompson <wt@electro-mechanical.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <46373873.6060704@rtr.ca> <463738BD.2090308@rtr.ca>
In-Reply-To: <463738BD.2090308@rtr.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> And this is the second one today where it would be very useful
> to see a tf dump.  It's time to add one to that code patch, methinks.

Yeah, we have all these fancy ata_msg_() thingies which can be used to
provide a lot of debugging info without affecting hot path.  We're just
too lazy to actually use it. :-( Putting it on my ever growing to-do list.

-- 
tejun
