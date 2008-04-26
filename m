Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYDZOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYDZOBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYDZOBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:01:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48277 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbYDZOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:01:06 -0400
Message-ID: <48133537.7040800@cs.helsinki.fi>
Date: Sat, 26 Apr 2008 16:59:19 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header
 file
References: <20080426134554.GA20727@damson.getinternet.no>
In-Reply-To: <20080426134554.GA20727@damson.getinternet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

Vegard Nossum wrote:
> @@ -0,0 +1,143 @@
> +#! /usr/bin/perl
> +#
> +# Detect cycles in the header file dependency graph
> +# Vegard Nossum <vegardno@ifi.uio.no>
> +#
> +
> +use strict;
> +use warnings;
> +
> +my @I = ('include');
> +my %deps = ();
> +
> +my @headers = grep { strip($_) } @ARGV;
> +
> +parse_all(@headers);
> +
> +detect_cycles(@headers);
> +#graph();

[snip]

> +exit;

> +# Output dependency graph in GraphViz language.
> +sub graph {

Shouldn't there be a command line option for printing out the GraphViz 
files?
