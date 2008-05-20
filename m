Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbYETAtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbYETAtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762520AbYETAtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:49:13 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:13588 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760364AbYETAtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=W4qJDqw5G3NvalEHbWR2lHwYloUPWzvA4X1rg/IAkifW2VjTH9e5S/rNF7bSxlaV9Vd+5wEZD2pfPh/hWvlZdaLws0/QFfKd+3Y8rkR76tuPPP3ztkNByGD/oZcoyskWcmMyrdmNnajNQ2z43E7quCRMQyVsFLOfzKNVz0HC4g4=
Subject: Re: [2.6.27 patch] the scheduled smbfs removal
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?G=FCnter?= Kukkukk <linux@kukkukk.com>,
       samba-technical@lists.samba.org, linux-cifs-client@lists.samba.org
In-Reply-To: <524f69650805191700g3e875e86gcb966033e9be60c1@mail.gmail.com>
References: <524f69650805191700g3e875e86gcb966033e9be60c1@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 May 2008 17:49:09 -0700
Message-Id: <1211244549.5915.111.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 19:00 -0500, Steve French wrote:
> Harvey Harrison <harvey.harrison@gmail.com> wrote on 05/19/2008 
> Note that some of the backlevel server support issues aren't handled
> by smbfs either (and are hard due to protocol limitations). Guenter
> Kukkukk had been tracking some of the issues with better backlevel
> support (mostly for OS/2 and Win9x servers) so he might have more
> information, but the obvious holes that come to mind are:
> 
> a) utimes to backlevel (lanman) servers
> b) For some pre-Unicode servers it would help to be able to change the
> code page used when translating readdir responses - so that we can
> convert the server's readdir results from the old DBCS code pages to
> UTF-8.
> c) optionally zeroing pages on the client to work around the few buggy
> old servers which don't zero on expanding file size remotely.
> d) support for ancient dos ("core smb") servers
> 
> There are also a few places where Jeff Layton noticed the cifs code
> would always try the more recent smb command (which fails) and only
> then issue the backlevel SMB command (in a few of the places, it would
> be safe to "remember" the "operation not supported" answer or
> equivalent so we don't have to first try a command which will always
> fail).

So it's generally people talking to older (or very old) servers that
would be affected by this?  What options would they have if smbfs were
removed?  Is there an alternative to smbfs that would work?  FUSE client?

(Not affected personally, just curious what the alternatives are where
cifs won't do it)

Harvey


