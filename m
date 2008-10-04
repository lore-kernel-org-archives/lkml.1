Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYJDRO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYJDRO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 13:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYJDROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 13:14:51 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:27994 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYJDROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 13:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=UXgM1k/8Dz1Uetz0mDVeP2QyZ7S1F7XbkKxLgfULed3TYuNsdG5OlBgY4MGGpxAj7R
         OxiilJoeA7JEYxBhlJymgHTegQAIvFbooLrDBk3gOX7myPT6NLAqSq9cm/5+HdyN9sSn
         6f9VtQVw6lMnEDMm7kB/5NFAFccxuXT3fw8xU=
Date: Sat, 4 Oct 2008 13:14:45 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081004171445.GA31780@nineveh.local>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002074523.GW19428@kernel.dk> <20081002010315.1cda8147.akpm@linux-foundation.org> <20081002120444.GA25164@mit.edu> <20081002061629.39d5e115@infradead.org> <20081002134659.GC25164@mit.edu> <20081002073304.7f027f52@infradead.org> <20081004141252.GA23398@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004141252.GA23398@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 10:12:52AM -0400, Theodore Tso wrote:

> Anyway, here's the patch (against ext4, although could pretty easily
> move this to ext3 --- but you can mount an ext3 filesystem as ext4,
> although for the moment you do have to run the command "tune2fs -E
> test_fs /dev/hdXX" first) [...]

Shouldn't he also be sure to mount the FS with the "noextents" option,
or has ext4 learned not to to enable extents if they're not already
enabled?

--
Joseph Fannin
jfannin@gmail.com

