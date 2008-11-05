Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKFHUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKFHUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYKFHUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:20:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39823 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752244AbYKFHUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:20:40 -0500
Date: Wed, 5 Nov 2008 16:57:54 +0100
From: Pavel Machek <pavel@suse.cz>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
Subject: Re: [PATCH 0/5] eCryptfs: Filename Encryption
Message-ID: <20081105155754.GA1759@ucw.cz>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-11-04 15:37:54, Michael Halcrow wrote:
> This patchset implements filename encryption via a passphrase-derived
> mount-wide Filename Encryption Key (FNEK) specified as a mount
> parameter. Each encrypted filename has a fixed prefix indicating that
> eCryptfs should try to decrypt the filename. When eCryptfs
> encounters

That is 'interesting'. What happens if normal filename has that
prefix? Should some out-of-band method be used to tell normal and
encrypted filenames apart?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
