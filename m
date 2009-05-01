Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbZEAWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbZEAWUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbZEAWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:20:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:43754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761674AbZEAWUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:20:23 -0400
Date: Sat, 2 May 2009 00:20:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Marc Pignat <Marc.Pignat@hevs.ch>
Cc: marcel@holtmann.org, ext-roger.quadros@nokia.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
In-Reply-To: <49FA604C020000BF000290B6@mailgw2.hevs.ch>
Message-ID: <alpine.LNX.2.00.0905020019360.22532@wotan.suse.de>
References: <49FA604C020000BF000290B6@mailgw2.hevs.ch>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Marc Pignat wrote:

> Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
> 
> add_conn and del_conn should be serialized, but flush_workqueue can't be used
> by the worker thread on it's own queue, so use flush_work to serialize add_conn
> and del_conn against each other.
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

Acked-by: Jiri Kosina <jkosina@suse.cz>

FWIW.

-- 
Jiri Kosina
SUSE Labs
