Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYAIHqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYAIHqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYAIHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:45:59 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:24846 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYAIHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:45:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=co8Zy5iAmt4IUTGlxL8nSCDdnCgt1GkzD4GXhmm9MhKv9VGI2p6BZLMqQgXtBaxx1VT2yDoeHlkL7/UdQ3lGc3S3uGOqI1OEPEcHFRcMyRneIDuR9K5qvihpxSkb8aqjPXWkKY2NbDhqoIhEUyeWNsu5sxiMm3guC0HqCXBXyXU=
Message-ID: <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
Date: Tue, 8 Jan 2008 23:45:56 -0800
From: "Valerie Henson" <val.henson@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: [RFD] Incremental fsck
Cc: "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801090740.12989.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801090022.55589.a1426z@gawab.com>
	 <20080108164106.735c431d@bree.surriel.com>
	 <200801090740.12989.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 8:40 PM, Al Boldi <a1426z@gawab.com> wrote:
> Rik van Riel wrote:
> > Al Boldi <a1426z@gawab.com> wrote:
> > > Has there been some thought about an incremental fsck?
> > >
> > > You know, somehow fencing a sub-dir to do an online fsck?
> >
> > Search for "chunkfs"
>
> Sure, and there is TileFS too.
>
> But why wouldn't it be possible to do this on the current fs infrastructure,
> using just a smart fsck, working incrementally on some sub-dir?

Several data structures are file system wide and require finding every
allocated file and block to check that they are correct.  In
particular, block and inode bitmaps can't be checked per subdirectory.

http://infohost.nmt.edu/~val/review/chunkfs.pdf

-VAL

-VAL
