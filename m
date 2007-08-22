Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbXHVAwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbXHVAwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 20:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXHVAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 20:52:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58386 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXHVAwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 20:52:42 -0400
Date: Wed, 22 Aug 2007 01:52:36 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, sam@ravnborg.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ver_linux is [censored]
Message-ID: <20070822005236.GF21089@ftp.linux.org.uk>
References: <20070821071938.GA17761@localhost.sw.ru> <9a8748490708210256v31a0ca00oa0d83dc401aeb98f@mail.gmail.com> <20070821231533.GE21089@ftp.linux.org.uk> <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490708211702q7ed2649ft978cea8ab07b63fa@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:02:44AM +0200, Jesper Juhl wrote:
> > How about simply doing
> > sh -c 'cat /proc/$$/maps'|sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}'
> > and to hell with parsing ls -l output?
> >
> Works for me.

or, simpler yet,

sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s//\1/;p;q}' </proc/self/maps
