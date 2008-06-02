Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYFBGHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYFBGHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYFBGHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:07:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:30895 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYFBGHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QjTIYlKsePNpY8p3h9H55wVI65mh7ec1faaaK02EVeqJlIlPwErYyQzzo4t2Ed1RSHPLj+rhiRNnW/QZ4u8MjDNiiqW02mrJsmPIEoz6aahVMu6EUWdF9EQNG690G7XGUcBgfMTljgNBD8mU4OfOrn43f7M4IHlefrAfh9K37uQ=
Message-ID: <344eb09a0806012307v8a8c0e4pd4ccfd27825cc0c4@mail.gmail.com>
Date: Mon, 2 Jun 2008 11:37:07 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Jamie Lokier" <jamie@shareable.org>,
       "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "David Newall" <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
In-Reply-To: <200806020437.m524bWiW027508@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9785.1212374902@jrobl>
	 <200806020437.m524bWiW027508@agora.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 10:07 AM, Erez Zadok <ezk@cs.sunysb.edu> wrote:
>
> Nevertheless, I can understand if the embedded community wants lightweight
> unioning.  Union Mounts initially may not support everything that unionfs
> does, but it should be smaller, and it should be enough I believe for the
> basic unioning uses --- perhaps even for the embedded community.  If so,
> then I suggest people offer to help Bharata and Jan Blunk's efforts, rather
> than [sic] cramming unioning into a single file system.
>

Though Union Mount effort has become slow and silent lately, some of
us are still working on it. While I worked on readdir support lately,
Jan Blunck and David Woodhouse are working on having a generic
whiteout support for linux.

Talking about help, Union Mount effort could take a generous help in
getting directory listing implementation right. We first tried to
handle duplicate elimination (during readdir) inside the kernel
entirely. The outcome was neither clean nor efficient.
(http://lkml.org/lkml/2007/12/5/147). Then there was a suggestion to
push the duplicate elimination to userspace. When that was tried out
(http://lkml.org/lkml/2008/4/29/248), we were told that NFS support is
going to be an issue. (BTW NFS support is going to be an issue
irrespective of where directory listing is implemented: kernel or
userspace). Some insights into  feasibility of supporting NFS with
Union Mount from people who understand NFS better would be very
helpful.

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
