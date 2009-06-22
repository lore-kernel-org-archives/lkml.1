Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbZFVVHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbZFVVHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZFVVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:06:58 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43801 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZFVVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vjZk3LJeCiGk6+OrTsU55fkkF+NoUEHhH16y5/ztPCmdRCIn+7jpwZ+ST10orH3FRn
         2WbF9NIt1037y/h1gQQv76BUCLEDkA89F+BXqfCx3DrbIJ73U8eYTk9G5Reeelf1TKPi
         9jUBDPn3f6xQcwAbJ6dlVkvBW7lpiyEva77x8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906221338360.3240@localhost.localdomain>
References: <alpine.LFD.2.01.0906221137580.3240@localhost.localdomain> 
	<1245699332-1872-1-git-send-email-vapier@gentoo.org> <alpine.LFD.2.01.0906221338360.3240@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 22 Jun 2009 17:00:11 -0400
Message-ID: <8bd0f97a0906221400n536a12b8hcfcb1b6c911543ac@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] FLAT: fix uninitialized ptr with 
	shared libs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Bernd Schmidt <bernds_cb1@t-online.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 16:48, Linus Torvalds wrote:
> On Mon, 22 Jun 2009, Mike Frysinger wrote:
>> should be cleaned up to apply to the master branch
>
> Hmm. Can somebody explain why we even bother to test bprm.cred for NULL
> that second time?

Bernd and/or David will have to cover this one

the previous discussion was here, but i dont think it answers the
questions you've raised:
http://thread.gmane.org/gmane.linux.hardware.blackfin.kernel.devel/1905
-mike
