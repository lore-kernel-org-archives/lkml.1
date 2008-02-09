Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYBIQUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYBIQUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYBIQSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:18:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:35087 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbYBIQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Gc2ZcomYM4Vi/id1q2jFjUV7YqvWLM2u1HVnY6vZe8SVwk46LuIWFwR3N9JpDJ4bOT2jcJY+BOgVJONU+7MU7SPJAbRlWSzqHtyJGFZYncjOb5eBg14DK//1G++zjvQgUKXcAw7MGjGLfb6gXizEGqLNlVh/UL+DW/bDuQGAxS4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: ide-tape redux (was: Re:)
Date: Sat, 9 Feb 2008 17:25:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <20080206052343.GA14349@gollum.tnic> <20080206052715.GB14349@gollum.tnic>
In-Reply-To: <20080206052715.GB14349@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802091725.29207.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008, Borislav Petkov wrote:
> ... and while we're at it ...
> 
> commit c824f79fe4040f7541d7e35c546bb57a22d2fe11
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Wed Feb 6 06:23:10 2008 +0100
> 
>     ide-tape: move all struct and other defs to the top
>     
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

looks good, but please do it before
"remove atomic test/set macros" patch
