Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZLUOPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZLUOPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZLUOPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:15:30 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49617 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZLUOP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:15:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z9/BrETwy/JaS1cnbu3pbc5TzIi6uEJacv+MkA3EtYTrsdzj1B6tb2BTqw6lrmju6d
         xZo+h1xiPA31N0S+d6aWeGmcZjq/dUamuFX1yWtB65UzslZ0hF/G3Ldic2Tds+TGcl0F
         MW0w9ST+swh7jphTVXniE1j6tqfHThxtY3HsA=
MIME-Version: 1.0
In-Reply-To: <20091221123654.GA9201@lst.de>
References: <4B2F6153.8010609@gmail.com> <20091221123654.GA9201@lst.de>
Date: Mon, 21 Dec 2009 22:15:26 +0800
Message-ID: <b3657a100912210615q1d55c334g73667e1c3a97ce05@mail.gmail.com>
Subject: Re: [PATCHv2 00/12]posix_acl: Add the check items
From: liu weni <qingshenlwy@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, joel.becker@oracle.com,
       cjb@laptop.org, jmorris@namei.org, serue@us.ibm.com,
       akpm@linux-foundation.org, adilger@sun.com, jack@suse.cz, tytso@mit.edu,
       dwmw2@infradead.xn.org.cpa, swhiteho@redhat.com, bfields@fieldses.org,
       neilb@suse.de, ffilzlnx@us.ibm.com, bharrosh@panasas.com,
       mfasheh@suse.com, tiger.yang@oracle.com, jeffm@suse.com, aelder@sgi.com,
       sandeen@sandeen.net, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       reiserfs-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       linux-mtd@lists.infradead.org, strongzgy@gmail.com, onlyflyer@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your suggestion.

In my opinion the null point is a incorrect state for the acl, then I
return -EINVAL.

I will check this state transition in XFS.

2009/12/21 Christoph Hellwig <hch@lst.de>:
> I like taking these checks into posix_acl_valid, but I think the patch
> submission needs a bit more work.
>
> All the patches are extremly whitespace mangled.  And I don't think
> splitting them up makes a whole lot of sense, when we do API changes
> like this we usually fix up all callers.  So please try to fix your
> mailer, merged them all into one, and maybe also chose a more
> descriptive subject line, e.g.
>
> Subject: take checks for NULL and error pointers into posix_acl_valid()
>
>
> And btw, at least the XFS change seems incorrect - previously we
> returned NULL acl pointer and this patch changes it to -EINVAL.
>
>
