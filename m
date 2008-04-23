Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYDWEV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYDWEV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 00:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYDWEVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 00:21:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50618 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYDWEVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 00:21:16 -0400
Message-ID: <480EB930.1040308@garzik.org>
Date: Wed, 23 Apr 2008 00:21:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Mark Lord <liml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com> <480DF7B7.9030000@rtr.ca> <480DF876.7070800@gmail.com> <480DF9BD.1080104@rtr.ca> <480DFE76.8000809@ru.mvista.com> <480E345D.9090406@ru.mvista.com> <480E9C15.6080103@gmail.com>
In-Reply-To: <480E9C15.6080103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Aik... We can do s/sff/tf/ and leave bmdma alone to avoid even more 
> confusion but sff has meant tf base interface for quite some time now in 
> libata and I think it'll be better to remember that sff is the new tf. 
> Sorry about the mess.


This renaming was discussed at the time on lkml and linux-ide, the 
patches and git pushes were CC'd, and I do not recall these complaints 
being raised at the time.

At this point, it's too ingrained in libata.  Another rename would IMO 
just cause more needless churn.

	Jeff


