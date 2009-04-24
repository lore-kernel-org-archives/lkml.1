Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZDXKib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZDXKib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZDXKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:38:22 -0400
Received: from mail.sdinet.de ([78.47.32.153]:36144 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbZDXKiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:38:21 -0400
Date: Fri, 24 Apr 2009 12:37:41 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Alessio Igor Bogani <abogani@texware.it>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suggestions request for speed-up kernel compilation
In-Reply-To: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904241235040.12781@aurora.sdinet.de>
References: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Alessio Igor Bogani wrote:

> I'm a kernel newbie and I would be very happy to receive some tips
> about kernel compilation from experienced developers.
> 
> I have recently elaborated some trivial patches. For each one I have
> done a build test at minimum and I find myself spend a lot of time
> waiting my Core Duo to accomplish this task. Make is a very smart tool
> but after a git pull or a git fetch origin/git reset --hard origin it
> can't help as desired.
> 
> Unfortunately I don't have a clustered compilation farm under my control. :-)
> 
> Anyone can suggest me how mitigate that issue?

What helps me with this is using ccache (compiler cache) - it keeps the 
compile results inside a cache and when compiling the same file again it 
fetches the result from there.

on debian it is just:
  apt-get install ccache
  export PATH=/usr/lib/ccache:$PATH
  ...work on kernel like normal...


c'ya
sven

-- 
The lights are fading out, once more...
