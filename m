Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbXIYMtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbXIYMtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbXIYMtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:49:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56577 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXIYMti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:49:38 -0400
Date: Tue, 25 Sep 2007 07:49:38 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
To: Jan Kara <jack@ucw.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       richard kennedy <richard@rsk.demon.co.uk>, sct@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
Message-ID: <20070925074938.2321bc15@gara>
In-Reply-To: <20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
References: <1190713240.3154.20.camel@castor.rsk.org>
	<20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
	<46F8EB26.2090104@linux.vnet.ibm.com>
	<20070925115046.GA15394@atrey.karlin.mff.cuni.cz>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 13:50:46 +0200
Jan Kara <jack@ucw.cz> wrote:
> > Jan Kara wrote:
> > >>
> > >-#define create_jbd_proc_entry() do {} while (0)
> > >-#define remove_jbd_proc_entry() do {} while (0)
> > >+static ctl_table fs_table[] = {
> > >+	{
> > >+                .ctl_name       = -1,	/* Don't want it */
> > 
> > 
> > 
> > shouldn't this be CTL_UNNUMBERED ?
>   Oh, it should be. I didn't notice we have this :) Thanks for notifying
> me. Attached is a fixed version.

This was fixed in JBD2 by moving the jbd-debug file to debugfs:
http://lkml.org/lkml/2007/7/11/334

Since this code is already in the kernel, we should keep it consistent. 

-JRS
