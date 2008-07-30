Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYG3CQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYG3CQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYG3CQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:16:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbYG3CQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:16:28 -0400
Date: Tue, 29 Jul 2008 19:16:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ben Collins <ben.collins@canonical.com>,
       Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH 4/7] nsc-ircc: Default to dongle type 9 on IBM hardware
Message-Id: <20080729191614.b8ee5fe8.akpm@linux-foundation.org>
In-Reply-To: <20080730014439.GA24409@srcf.ucam.org>
References: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
	<1216618176.8411.124.camel@violet.holtmann.net>
	<1216662057.7585.153.camel@cunning>
	<20080728194612.01068283.akpm@linux-foundation.org>
	<20080730014439.GA24409@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 02:44:39 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Jul 28, 2008 at 07:46:12PM -0700, Andrew Morton wrote:
> > The changelog doesn't exist^Wexplain the reasons for this patch.
> > 
> > I assume it fixes some bug?  What is it?
> 
> It's necessary to set the dongle type on the nsc driver in order to get 
> it to work correctly. Thinkpads all appear to use dongle type 9. This 
> patch defaults nsc devices with an IBM PnP descriptor to use type 9.
> 

So it makes thinkpads work?  That's useful info.

We're getting there.  Who actually authored the patch?
