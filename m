Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYLTQWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYLTQWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 11:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYLTQV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 11:21:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48492 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYLTQV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 11:21:57 -0500
Date: Sat, 20 Dec 2008 17:34:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 26/26] kbuild: support switching source directories with O=.. builds
Message-ID: <20081220163423.GR25779@one.firstfloor.org>
References: <20081220142518.GA19390@uranus.ravnborg.org> <1229783497-19550-26-git-send-email-sam@ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229783497-19550-26-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 03:31:37PM +0100, Sam Ravnborg wrote:
> It was not possible to use the same output directory
> for two different source repositories becuase the asm
> symlink in include2/asm would point to the first repository.
> 
> We now create the symlink each time thus allowing switch
> between different source repositories.
> 
> This feature was requested by Andi Kleen.

Thanks. But it's not really a new feature, this used to work and just
broke at some point. I would consider it a regression fix.

-Andi

