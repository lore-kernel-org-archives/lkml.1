Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZEYMei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZEYMei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZEYMea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:34:30 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:58473 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZEYMe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:34:29 -0400
Date: Mon, 25 May 2009 14:34:30 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       tytso@thunk.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Message-ID: <20090525123430.GA5534@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <20090524101551.57b706e9@infradead.org> <20090524173933.GD24753@cip.informatik.uni-erlangen.de> <20090525120320.GA25908@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525120320.GA25908@mit.edu>
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ted,

> Yes, it does, sb_issue_discard().  So if you wanted to hook into this
> routine with a function which issued calls to zero out blocks, it
> would be easy to create a private patch.

that sounds good because it wouldn't only target the most used
filesystem but every other filesystem that uses the interface as well.
Do you think that a tunable or configurable patch has a chance to hit
upstream as well?

        Thomas
