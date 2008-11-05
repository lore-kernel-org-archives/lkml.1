Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYKEUGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYKEUGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYKEUGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:06:45 -0500
Received: from lazybastard.de ([212.112.238.170]:55725 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbYKEUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:06:44 -0500
Date: Wed, 5 Nov 2008 21:06:35 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library V2
Message-ID: <20081105200635.GE6561@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <20081101155958.GA28776@logfs.org> <1225915040.3619.155.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225915040.3619.155.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 November 2008 20:57:20 +0100, Johannes Berg wrote:
> 
> That sounds fair, after all at least it limits the tree size, but I'm
> too lazy to calculate the worst case right now.

Worst case you have a single entry next to a full node, then split the
full node, etc.  So slightly more than 1/4 populated.

> I'd use this as-is for the WIP cfg80211 code that keeps track of BSSes,
> as a hash-table/list on steroids.

Excellent.  With this trojan horse in place I don't have to worry much
about a competing library with a different interface.  Famous last
words. :)

Jörn

-- 
The wise man seeks everything in himself; the ignorant man tries to get
everything from somebody else.
-- unknown
