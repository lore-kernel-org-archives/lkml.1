Return-Path: <linux-kernel-owner+w=401wt.eu-S934768AbYAaST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbYAaST3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbYAaSTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:19:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:4702 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934296AbYAaSTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:19:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=k+73/p5b3qhNkz6hRULBHR51McO+S0vYBCE1hZ/AziGHyaH+QfsKIJGGjwR764lBrXIX184jeMfAWijPPKCyKg08cBmI83oP+WGquK/5MN6MIkGH3y0F89m/3YP8/jhcamjRYgOpl4sYBfYkZjEqaqCEL5gT8PyvQcQcHeiJzPE=
Date: Thu, 31 Jan 2008 19:18:21 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] udf: truncate: create function for updating of
	Allocation Ext Descriptor
Message-ID: <20080131181813.GA6222@joi>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-7-git-send-email-marcin.slusarz@gmail.com> <20080131170858.GK1461@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131170858.GK1461@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 06:08:58PM +0100, Jan Kara wrote:
> On Wed 30-01-08 22:03:56, marcin.slusarz@gmail.com wrote:
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Jan Kara <jack@suse.cz>
>   There are at least a few other places in inode.c which do exactly what
> you do in udf_update_alloc_ext_desc() so these should be converted as well.

I noticed that too, but it's not clear to me how to do it properly.

Marcin
