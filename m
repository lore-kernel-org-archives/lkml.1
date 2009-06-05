Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZFERqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZFERqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZFERqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:46:32 -0400
Received: from kroah.org ([198.145.64.141]:48687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZFERqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:46:32 -0400
Date: Fri, 5 Jun 2009 10:41:32 -0700
From: Greg KH <greg@kroah.com>
To: Pranith Kumar <pranith.hacks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Are patches for warnings in drivers/staging/* worth?
Message-ID: <20090605174132.GC6479@kroah.com>
References: <4A28B566.1010105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28B566.1010105@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 11:34:22AM +0530, Pranith Kumar wrote:
> Hi Greg,
> 
> I am looking at the various warnings which occur while compiling the 
> staging drivers. Most of them are
> 
> * unused variables
> * arg makes pointer from integer without cast
> * un-initialized variable
> 
> What in these warnings should I send patches against? Are they worth the 
> effort?

Sure they are worth the effort in cleaning up this kind of things.
Always generate patches for the staging tree against the latest
linux-next release.

thanks,

greg k-h
