Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYDDFHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYDDFHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYDDFH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:07:27 -0400
Received: from 1wt.eu ([62.212.114.60]:1144 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYDDFH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:07:26 -0400
Date: Fri, 4 Apr 2008 07:07:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Richard MUSIL <richard.musil@st.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Problem with accessing stable git over http
Message-ID: <20080404050718.GE23796@1wt.eu>
References: <47EA26E4.8060602@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EA26E4.8060602@st.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 11:35:16AM +0100, Richard MUSIL wrote:
> For some reason I cannot access stable kernel git branches over http
> since version 2.6.23.y.
> 
> HTTP access is working for 2.6.22.y
> (http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git)
> - I can fetch from it. It is also working for Linus' dev branch
> (http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
> which I clone.
> But for stable 2.6.23.y and 2.6.24.y, when I try fetch, I get in particular:
> 
> HTTP GET
> http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git/info/refs
> HTTP/1.1
> HTTP HTTP/1.1 404 Not Found (text/html)
> 
> I am behind proxy and firewall and I cannot use git protocol.
> 
> Does anyone know, what might be a problem? It kind of makes the sources
> unreachable for me :(.

what version of git are you using ? Those files indeed do not exist in
either repository, so it would be good to find why git tries to fetch
them.

> Thanks,
> Richard

regards,
Willy

