Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbZAHTq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbZAHTq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZAHTqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:46:47 -0500
Received: from lazybastard.de ([212.112.238.170]:52996 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZAHTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:46:46 -0500
Date: Thu, 8 Jan 2009 20:46:38 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library V2
Message-ID: <20090108194638.GC24884@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes> <20090108162429.GA24884@logfs.org> <1231433404.8398.1.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231433404.8398.1.camel@johannes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 January 2009 17:50:04 +0100, Johannes Berg wrote:
> 
> I see this:
> 
> 
> - * Second trick is to special-case the key "0" or NUL.  As seen above, this
> - * value indicates an unused slot, so such a value should not be stored in the
> - * tree itself.  Instead it is stored in the null_ptr field in the btree_head.
> 
> Does that mean that wasn't true, and I can store a 0 key?

Ahh, don't look at that!  The embarrassment is unbearable!  Go away!

Yes, I used to have a special exception for a 0 key.  But I also have
a special exception for a NULL value and can test against that instead
of testing against a 0 key.  It is even faster, because the value is not
variable-sized.  In hindsight it is hard to explain why I ever did that.

Jörn

-- 
Unless something dramatically changes, by 2015 we'll be largely
wondering what all the fuss surrounding Linux was really about.
-- Rob Enderle
