Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbYBUATO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbYBUATO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYBUASx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:18:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36833 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbYBUASv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:18:51 -0500
Date: Wed, 20 Feb 2008 16:15:35 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Olsa <olsajiri@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs: removing unused fops from struct char_device_struct
Message-ID: <20080221001535.GA23986@kroah.com>
References: <47BC9433.8020905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC9433.8020905@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 09:57:23PM +0100, Jiri Olsa wrote:
> Hi,
> 
> seems struct char_device_struct::fops is no longer used, removing it.
> I checked with "make allyesconfig" and got proper compile.
> 
> Signed-off-by: Jiri Olsa <olsajiri@gmail.com>

Hm, why send this to me?

Did I make the mistake of touching this file last?  Hm, nope, someone
else touched it after I did, I'm safe :)

Seriously, I have no problem with this, but it should probably go
through Andrew.

thanks,

greg k-h
