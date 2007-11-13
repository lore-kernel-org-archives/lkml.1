Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbXKMDJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbXKMDJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 22:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXKMDJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 22:09:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:58468 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXKMDJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 22:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=o54Awx6lxkKVFfngR/DM/tL+ehmkgEQ3Ao8YWoKBBTcDjAMDDrQADZMOQdDmeAWYijp3gM2itTwzdv1YRBSYk9ge70wEWk6kq/vgSV5qYgC3SR5glq5R50vaaKJWG26oXvd+qChVVaY5BuTVK4uK4P3g1PM5TCmPxGphSaZSmec=
Message-ID: <ed10ee420711121909y3e0f84d0hd07c331a9a0aba66@mail.gmail.com>
Date: Mon, 12 Nov 2007 19:09:42 -0800
From: "SL Baur" <steve@xemacs.org>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
In-Reply-To: <17306.1194909291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071110181416.31dc2614.akpm@linux-foundation.org>
	 <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	 <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
	 <6214.1194881680@redhat.com>
	 <20071112115353.227f35cb.akpm@linux-foundation.org>
	 <ed10ee420711121450m5aec7c06vf4481ebad944d706@mail.gmail.com>
	 <17306.1194909291@redhat.com>
X-Google-Sender-Auth: b7f4aeed4aef5d03
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/07, David Howells <dhowells@redhat.com> wrote:
> SL Baur <steve@xemacs.org> wrote:
>
> > (push '("/Kbuild" . makefile-mode) auto-mode-alist)
>
> Does that work for Kbuild.asm too, more to the point?

Of course.  It works for any filename beginning with the string "Kbuild".  Major
mode rules are on a first match basis, so you have to make sure this rule is
ahead of the .asm rule.  I'll push a patch to the XEmacs guys so it works this
way by default, someone else can deal with Stallman.

Please take the emacsism out of the file as it bothers Andrew and others.

-sb
