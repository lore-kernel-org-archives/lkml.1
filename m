Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZCXWLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZCXWLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZCXWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:11:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZCXWLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:11:23 -0400
Date: Tue, 24 Mar 2009 15:01:36 -0700
From: Greg KH <gregkh@suse.de>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] [staging] changed ioctls to unlocked
Message-ID: <20090324220136.GA12128@suse.de>
References: <1237929168-15341-2-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237929168-15341-2-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:12:36PM -0500, stoyboyker@gmail.com wrote:
> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>

Hm, why?  What does this patch accomplish becides just pushing the
lock_kernel into the driver?  Shouldn't you fix the code to not need the
lock_kernel at all instead?

thanks,

greg k-h
