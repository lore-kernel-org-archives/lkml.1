Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbXE1ATE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbXE1ATE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 20:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXE1ASz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 20:18:55 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300AbXE1ASy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 20:18:54 -0400
Date: Sun, 27 May 2007 17:18:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-Id: <20070527171817.4ce9d40d.akpm@linux-foundation.org>
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007 18:11:25 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> +#gotos aren't indented
> +		if($line=~/^\s*[A-Za-z\d_]+:/ and !($line=~/^\s*default:/)){
> +			print "Gotos should not be indented\n";
> +			print "$herecurr";
> +			$clean = 0;
> +		}

This should be "labels".  Plus a lot of people do indent the labels by
a single space to avoid confusing `diff -p', which seems a reasonable
thing to not complain about.
