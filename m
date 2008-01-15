Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYAOJp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYAOJp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYAOJpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:45:14 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:20184 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYAOJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:45:11 -0500
Date: Tue, 15 Jan 2008 10:45:02 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, stern@rowland.harvard.edu,
       dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
Message-ID: <20080115104502.4cb1798e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080115091322.GA3186@darkstar.te-china.tietoenator.com>
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	<20080115091322.GA3186@darkstar.te-china.tietoenator.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 17:13:22 +0800,
Dave Young <hidave.darkstar@gmail.com> wrote:

> 
> Add the following class iteration functions for driver use:
> class_for_each_device
> class_find_device
> class_for_each_child
> class_find_child
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

> 
> ---
>  drivers/base/class.c   |  159 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |   11 ++-
>  2 files changed, 168 insertions(+), 2 deletions(-)
