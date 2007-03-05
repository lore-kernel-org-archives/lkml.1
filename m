Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXCEPZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXCEPZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932966AbXCEPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:25:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:60306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914AbXCEPZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:25:43 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/2] x86_64: add reporting of SVM flags to /proc/cpuinfo
Date: Mon, 5 Mar 2007 16:25:31 +0100
User-Agent: KMail/1.9.5
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
References: <20070305143601.GF30318@amd.com> <20070305143911.GG30318@amd.com>
In-Reply-To: <20070305143911.GG30318@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051625.31449.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 15:39, Joerg Roedel wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> 
> This patch adds the advanced SVM reporting to /proc/cpuinfo on the x86_64
> architecture.

Adding more fields to /proc/cpuinfo is always somewhat risky because
there are lots of badly written parsers for it.

I considered adding the SVM fields myself, but decided against it because
it didn't seem generally useful enough.

-Andi
