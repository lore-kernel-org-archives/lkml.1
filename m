Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYLKKlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYLKKlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYLKKl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:41:28 -0500
Received: from brick.kernel.dk ([93.163.65.50]:25890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbYLKKl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:41:27 -0500
Date: Thu, 11 Dec 2008 11:41:10 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081211104109.GF23742@kernel.dk>
References: <20081211111614.493d2a62@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211111614.493d2a62@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11 2008, Jean Delvare wrote:
> Configuration option LSF has a default which contradicts its help
> text. The help text says "if unsure, say Y" but there is no explicit
> default, and the default default is N.
> 
> This inconsistency was introduced by commit
> 88b9adb073b7a69a54b1b14423103bc24587ebdc. According to the commit
> message, we want users to enable this option, so it should default to
> Y.

I wonder if we just shouldn't get rid of this option and just have the
single CONFIG_LBD option control both of these. If you set CONFIG_LBD,
you probably want large files as well. And CONFIG_LSF without CONFIG_LBD
doesn't make a lot of sense.

Would anyone object to such a change?

-- 
Jens Axboe

