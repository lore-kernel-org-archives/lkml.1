Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbXJZTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbXJZTZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJZTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:25:39 -0400
Received: from main.gmane.org ([80.91.229.2]:52916 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbXJZTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:25:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Fri, 26 Oct 2007 21:25:14 +0200
Message-ID: <ffteuq$n3b$1@ger.gmane.org>
References: <fft89p$rko$1@ger.gmane.org> <20071026190500.GA23480@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c6db3.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <20071026190500.GA23480@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So here you do not have a .config file in the directory: /usr/src/obj/linux/2.6.23.1/x86_64/adjusted
> So you are told to create one using some of the available methods.

The README contains the following description.

"...
	"make oldconfig"   Default all questions based on the contents of
			   your existing ./.config file and asking about
			   new config symbols.
	"make silentoldconfig"
			   Like above, but avoids cluttering the screen
			   with questions already answered.
..."

I did not expect that there are more differences besides the "silence".


> The suggested way to fix it is to run "make mrproper"

I did that clean-up step.


> but in your case you would then delete all the output files of your vendor supplied kernel.

I hope not because I've setup symbolic links to point to the current release as far I know
instead of the release "2.6.22.9-0.4-default" that I am using at the moment.


> This is something internal make stuff that is irrelevant in this case.

It is relevant in my case if I want to use different output directories for parallel
builds from the same source directory.

Regards,
Markus

