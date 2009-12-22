Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZLVOs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZLVOs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 09:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZLVOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 09:48:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56320 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZLVOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 09:48:56 -0500
Date: Tue, 22 Dec 2009 14:48:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: liu weni <qingshenlwy@gmail.com>
Cc: chris.mason@oracle.com, joel.becker@oracle.com, cjb@laptop.org,
       jmorris@namei.org, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, onlyflyer@gmail.com, strongzgy@gmail.com
Subject: Re: [PATCHv2 02/12]posix_acl: Add the check items
Message-ID: <20091222144851.GS18217@ZenIV.linux.org.uk>
References: <4B2F619A.8000407@gmail.com> <20091222120803.GR18217@ZenIV.linux.org.uk> <b3657a100912220631n4d69ea66x23c1296e1abc468a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3657a100912220631n4d69ea66x23c1296e1abc468a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 10:31:38PM +0800, liu weni wrote:
> Hi All:
> 
>     I'm sorry for my stupid. I am crazy for fixing this bug.
> And make so much mistake.

Welcome to the club.  It's OK, _everyone_ around here had done that.
Many times.

> Maybe I need cool down and think more.
 
Always a good advice, but in this case it's a bit more specific - if you
see that you are modifying behaviour for some arguments, figure out what
would lead to such arguments and see if that behaviour is intentional ;-)
And if after that you are still not sure whether it's a bug or not, ask the
people involved what the hell had they intended to happen in such-and-such
case (often enough that'll bring variants of "nice catch" - bugs *do* happen).
