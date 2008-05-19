Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYESA3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYESA3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYESA31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:29:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59396 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbYESA30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:29:26 -0400
Date: Sun, 18 May 2008 20:28:38 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080519002838.GB8335@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516220315.GB15334@shareable.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 11:03:15PM +0100, Jamie Lokier wrote:
> The MacOS X folks decided that speed is most important for fsync().
> fsync() does not guarantee commit to platter.  *But* they added an
> fcntl() for applications to request a commit to platter, which SQLite
> at least uses.  I don't know if MacOS X uses barriers for filesystem
> operations.

Out of curiosity, exactly *what* semantics did MacOS X give fsync(),
then?  Did it simply start the process of staging writes to disk, but
not wait for the writes to hit the platter before returning?  That's
basically the equivalent of ext3's barrier=0.

							- Ted
