Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYG2PBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYG2PBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYG2PBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:01:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:2426 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYG2PBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=To+QzPXPNGv4e0bjVHKZVHqTQkHPyx2+V42TMkCyyL3c7tRPWvbYyu7PxHwjjSQ8Kj
         v4Dl6cPGHDU+E3MpwXXSDX57pQCstFhzXXKeQQLHHsvCplqKslM9Rtq2dUj5uyUUa8Xg
         DYRCxgl6BHX/ZpKQEnUo+w9gGOlwQ3MTP+AQs=
Message-ID: <ef1cd66f0807290801q647d7efbn9f9058531bc6f32c@mail.gmail.com>
Date: Tue, 29 Jul 2008 16:01:01 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: schwidefsky@de.ibm.com
Subject: Re: [patch 02/15] kmsg: Kernel message catalog script.
Cc: "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, "Michael Holzheu" <holzheu@de.ibm.com>
In-Reply-To: <1217329750.10259.38.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080728175355.734299984@de.ibm.com>
	 <20080728175511.260174666@de.ibm.com>
	 <20080728192828.GA11431@uranus.ravnborg.org>
	 <1217320950.10259.15.camel@localhost>
	 <20080729084536.GA29659@uranus.ravnborg.org>
	 <1217329750.10259.38.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

I think the changelog needs fixing, too:

2008/7/29 Martin Schwidefsky <schwidefsky@de.ibm.com>:
> The kmsg check is invoked with "make K=1" and reads the source files for
> all objects that are built by the current configuration and searches for
> matching kmsg descriptions for the kmsg messages in the source which
> have a messages id > 0. If a message description can not be found the
> script prints a blueprint and causes a make error.
>
> The kmsg man page creation is invoked with "make K=2" and reads the source
> files for all built objects, looks up the message description and writes
> a man page to $(objtree)/man.
This should be "D=1" and "D=2" now, shouldn't it?

I hope this helps,
Jochen
-- 
http://seehuhn.de/
