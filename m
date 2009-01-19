Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbZASRKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbZASRKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZASRKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:10:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZASRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:10:10 -0500
Message-ID: <4974B3B7.5060608@zytor.com>
Date: Mon, 19 Jan 2009 09:09:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "SergeE.Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] autofs: fix the wrong usage of the	deprecated	task_pgrp_nr()
References: <20090118073441.GA699@redhat.com>	 <1232331602.3136.19.camel@zeus.themaw.net>  <49741F14.80808@zytor.com> <1232351101.3136.87.camel@zeus.themaw.net>
In-Reply-To: <1232351101.3136.87.camel@zeus.themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote:
>>>
>> The other thing is also: isn't it high time to remove autofs 3?  It has
>> been unmaintained for at least 10 years now.  I should know ;)
> 
> That's a good idea.
> Couldn't we rename autofs4 to autofs and add a MODULE_ALIAS("autofs4")
> or something?
> 

Works for me.  Now, this really isn't an -rc2 kind of thing, but I would
ACK such a change for the next merge window.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

