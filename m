Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbYEDRd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbYEDRd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYEDRdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:33:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42464 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYEDRdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:33:12 -0400
Date: Sun, 4 May 2008 18:33:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [vfs/proc] task_nommu: fix compile failing bug
	because of spilt file.h
Message-ID: <20080504173305.GK5882@ZenIV.linux.org.uk>
References: <1209913975-19242-1-git-send-email-cooloney@kernel.org> <20080504153056.GJ5882@ZenIV.linux.org.uk> <386072610805041025w7120539fp1f8efb86e20da5b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610805041025w7120539fp1f8efb86e20da5b4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 01:25:37AM +0800, Bryan Wu wrote:

> Wow, my patch is just to kill the compile error, I did not notice this
> large size issue here.
> I'd like to improve this code later.

I certainly have no objections to the patch as is - the include is
obviously missing.
