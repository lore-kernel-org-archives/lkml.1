Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbZAWBtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbZAWBtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbZAWBtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:49:35 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:51591 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbZAWBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:49:34 -0500
Date: Fri, 23 Jan 2009 02:49:30 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       stefan.bader@canonical.com, Suresh Jayaraman <sjayaraman@suse.de>,
       Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
       Steve French <smfrench@gmail.com>
Subject: Re: [linux-cifs-client] BUG: Possible cifs+IPv6-Regression
	2.6.27.4 -> 2.6.27.9
Message-ID: <20090123014930.GA6579@pest>
References: <20090118221329.GA12742@pest> <20090118210314.30832598@tleilax.poochiereds.net> <20090119103248.GA28699@schleppi.birkenwald.de> <20090119160725.34124637@tleilax.poochiereds.net> <20090119213819.GA6532@pest> <20090122094517.42e724e4@barsoom.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122094517.42e724e4@barsoom.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 09:45:17AM -0500, Jeff Layton wrote:

> I think I may see the bug...
> 
> I think the "addr" struct in cifs_mount is too small for ipv6 addresses.
> Here's a proposed patch for 2.6.27.y. Could you apply it and let me
> know if it fixes the bug?

I can confirm that Ubuntu kernel 2.6.27-11.25 (which has only your patch
in the changes) fixes this issue.

Thanks a lot,
Bernhard
