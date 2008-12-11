Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYLKK7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYLKK7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYLKK66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:58:58 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46608 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbYLKK65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:58:57 -0500
Date: Thu, 11 Dec 2008 11:58:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081211115844.1b1dbf49@hyperion.delvare>
In-Reply-To: <20081211104109.GF23742@kernel.dk>
References: <20081211111614.493d2a62@hyperion.delvare>
	<20081211104109.GF23742@kernel.dk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 11:41:10 +0100, Jens Axboe wrote:
> On Thu, Dec 11 2008, Jean Delvare wrote:
> > Configuration option LSF has a default which contradicts its help
> > text. The help text says "if unsure, say Y" but there is no explicit
> > default, and the default default is N.
> > 
> > This inconsistency was introduced by commit
> > 88b9adb073b7a69a54b1b14423103bc24587ebdc. According to the commit
> > message, we want users to enable this option, so it should default to
> > Y.
> 
> I wonder if we just shouldn't get rid of this option and just have the
> single CONFIG_LBD option control both of these. If you set CONFIG_LBD,
> you probably want large files as well. And CONFIG_LSF without CONFIG_LBD
> doesn't make a lot of sense.
> 
> Would anyone object to such a change?

No objection from me, getting rid of configuration options almost
always gets my vote :)

-- 
Jean Delvare
