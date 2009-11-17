Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbZKQB5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbZKQB5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZKQB46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:56:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbZKQB4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:56:53 -0500
Date: Mon, 16 Nov 2009 17:38:50 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] lp: move compat_ioctl handling into lp.c
Message-ID: <20091117013850.GB8030@suse.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
 <1258331227-1694-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258331227-1694-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 12:27:04AM +0000, Arnd Bergmann wrote:
> Handling for LPSETTIMEOUT can easily be done in lp_ioctl, which
> is the only user. As a positive side-effect, push the BKL
> into the ioctl methods.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
