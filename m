Return-Path: <linux-kernel-owner+w=401wt.eu-S1765676AbXJOTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765676AbXJOTRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXJOTRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:17:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:38889 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbXJOTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=XbmxauiVj/I6/IwZKNobRESOaw79LLhCv6OcV7QJyNgL7W2qv6xga3NniqtScWQP16UqLuLc40BfCCPfHEH1XgyDGP2OPaj9VfqXeguKIhrRdJ2Rk0cq5gYqhx2aJptlSr97JGNOonlvbOLdscc5rtVol0XcuEuha81kAF3AdFQ=
Date: Mon, 15 Oct 2007 23:17:32 +0400
To: Mark Gross <mgross@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015191732.GA1841@martell.zuzino.mipt.ru>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015170411.GB18550@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:04:11AM -0700, Mark Gross wrote:
> On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
> > http://kernelnewbies.org/KernelProjects
> 
> Is there already a make config option that will do a good job at setting
> a default .config file based on what is already running on a system?  
> 
> I get tiered of trimming down my .config for my laptop build so it takes
> less than 30min to build a kernel.

Ehh? You do it once, then leave it aside or in /proc/config.gz, on new
kernel copy it back, "make oldconfig", answer several questions and here
we go.

> Bonus credit to additional "expert" options (like those powertop puts
> out) for target uses, laptop, HPC, home file share, embedded targets....
> 
> Oh, and lets make the expert configs easily extensible.
