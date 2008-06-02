Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYFBPb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYFBPb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYFBPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:31:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:25601 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYFBPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lZ24MM492huDPQkPYdcEKOaOprrYtHzFAgPe8nheopabxsPieSBRG9ljZP5ZmHrUjNasJBaPJ4dAdz8D5jfgjdOYystRQZ2HnW4qhXTXVcHaShtPbsOYzWUEHJare2L0KJ6+U2nZ8UeOOqcwiK9alb1yi6bSxe43pln8ekbfaTE=
Message-ID: <9d732d950806020831h1b8aeabag9cb6db8e16bac971@mail.gmail.com>
Date: Tue, 3 Jun 2008 00:31:14 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [patch 01/15] security: pass path to inode_create
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080602150517.GB22400@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080531083052.GH24135@infradead.org>
	 <20080602060144.GA11564@infradead.org>
	 <E1K343a-0002dG-C9@pomaz-ex.szeredi.hu>
	 <20080602091341.GA8011@infradead.org>
	 <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu>
	 <20080602093630.GA25254@infradead.org>
	 <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu>
	 <20080602104203.GA21898@infradead.org>
	 <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu>
	 <20080602150517.GB22400@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/3 Evgeniy Polyakov <johnpol@2ka.mipt.ru>:
> On Mon, Jun 02, 2008 at 12:55:33PM +0200, Miklos Szeredi (miklos@szeredi.hu) wrote:
>> Oh, I've been told.  But valid technical reason given?  No.
>
> This is a really interesting flame, can you proceed,
> we will run for cola and peanuts :)

Let me quote a message by Chris Wright from LSM ml:
"You cannot discover the path used to access an inode without knowing
both the dentry and the vfsmount objects. "

Another one by Stephen Smalley:
"Pathname-based security considered harmful.  You want to control access
to an object, not a name, and the name-to-object mapping is neither
one-to-one nor immutable."

Can you guess when they were posted?
The answer is December 2003. :)
Do we need more time? I don't think so.

I'm viewing Miklos' patches as *enhancements* not only for AppArmor (and
other pathname-based LSM modules). Everyone can make use of
information and lose nothing.  Am I too simple minded?

> For the technical reason: in case of stackable/bind, which path should
> be checked? Whatever answer is, there will always be another party,
> which wants different behaviour.

-- 
Toshiharu Harada
haradats@gmail.com
