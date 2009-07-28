Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZG1PHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZG1PHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZG1PHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:07:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40256 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbZG1PHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:07:17 -0400
Date: Tue, 28 Jul 2009 09:07:16 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nicolas Palix <npalix@diku.dk>
Cc: Greg KH <gregkh@suse.de>, hjanssen@microsoft.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Transform PDEVICE_OBJECT and
	DEVICE_OBJECT typedefs into their corresponding structs
Message-ID: <20090728150716.GH3711@parisc-linux.org>
References: <200907281030.45317.npalix@diku.dk> <20090728144123.GB13883@suse.de> <200907281701.43509.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907281701.43509.npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 05:01:42PM +0200, Nicolas Palix wrote:
> Ok. So, I guess the pattern for the other typedef is to strip the _OBJECT
> suffix when present, and always add the prefix hv_, right ?

The 'pattern' is to look at what the code is doing and choose a sensible
name.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
