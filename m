Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYLJMkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYLJMkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYLJMjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:39:55 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:45264 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYLJMjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:39:54 -0500
Date: Wed, 10 Dec 2008 13:41:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] makesystem: revive cscope target
Message-ID: <20081210124120.GA12784@uranus.ravnborg.org>
References: <1228911013-25641-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228911013-25641-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 01:10:13PM +0100, Jiri Slaby wrote:
> - export src and obj, so that we can check them in tags.sh
> - don't allow * expansion during sh function calls

What benefit does this patch give us?
We do not use $obj neither $src in tags.sh.

Likewise we do not pass it non-expanded parameters.

	Sam
