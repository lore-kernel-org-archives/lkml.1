Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYJZRis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYJZRis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 13:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbYJZRik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 13:38:40 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:38340 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYJZRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 13:38:40 -0400
Subject: Re: [PATCH] DASD: send 'change' uevents
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michael Holzheu <HOLZHEU@de.ibm.com>,
       Stefan Weinhuber <wein@de.ibm.com>
In-Reply-To: <49016599.5030406@suse.de>
References: <49016599.5030406@suse.de>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 26 Oct 2008 19:29:57 +0100
Message-Id: <1225045797.14057.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Fri, 2008-10-24 at 08:05 +0200, Hannes Reinecke wrote:
> this patch modifies the DASD driver to sent out 'change' events
> whenever the internal state machine transitions in or out of the
> 'ready' state. This is required for udev so that vol_id and friends
> can actually read from the disk.
> 
> Please apply.

Looks reasonable to me. Stefan can you take a look at this please?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


