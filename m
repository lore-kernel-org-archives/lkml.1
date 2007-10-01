Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbXJAHTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbXJAHTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXJAHT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:19:28 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40502 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXJAHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:19:27 -0400
Message-ID: <47009F76.9050802@bull.net>
Date: Mon, 01 Oct 2007 09:19:18 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.linux.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mtk-manpages@gmx.net
Subject: Re: [RFC][PATCH 0/2] New API to change the IDs of an existing IPC
References: <20070928165829.5da76796.Pierre.Peiffer@bull.net> <517f3f820709292330i56caf106yfa18778d741f8e1a@mail.gmail.com>
In-Reply-To: <517f3f820709292330i56caf106yfa18778d741f8e1a@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/10/2007 09:25:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/10/2007 09:25:34,
	Serialize complete at 01/10/2007 09:25:34
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Michael Kerrisk a écrit :
> Hi Pierre,
> 
>>         As I'm seeing some discussion/interest about IPC, I would like to propose
>>  these patches, which provide an easy way to change the ID of an exiting IPC.
>> This work is done around the checkpoint/restart of applications. In the case of
>> the IPCs, we need (among others) this functionality.
> 
> Can you give some more detailed explanation of why this
> functionaility is needed.  

Sure; in the case of the checkpoint/restart, when you restart an application, what you want is to recreate all system ressources with the same properties they had, when you have checkpointed it.
For IPCs, this means that you need to recreate all the IPCs with the same IDs (at least).
For now, this ID is computed by the system when an IPC is created and you can't specify or modify it.

These patches give you the possibility of changing this ID once the IPC is created.

-- 
Pierre Peiffer
