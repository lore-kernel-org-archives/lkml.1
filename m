Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbXIYGyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbXIYGyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXIYGyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:54:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1947 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXIYGyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:54:18 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: linux@horizon.com
Cc: vegard.nossum@horizon.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070925045808.12273.qmail@science.horizon.com>
References: <20070925045808.12273.qmail@science.horizon.com>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 23:54:14 -0700
Message-Id: <1190703254.3964.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 00:58 -0400, linux@horizon.com wrote:
> Even the "kp_" prefix is actually pretty unnecessary.  It's "info"
> and a human-readable string that make it recognizable as a log message.

While I agree a prefix isn't necessary, info, warn, err
are already frequently #define'd and used.

kp_<level> isn't currently in use.

$ egrep -r -l --include=*.[ch] "^[[:space:]]*#[[:space:]]*define[[:space:]]+(info|err|warn)\b" * | wc -l
29


