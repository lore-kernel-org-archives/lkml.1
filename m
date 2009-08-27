Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZH0XLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZH0XLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 19:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZH0XL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 19:11:29 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36699 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZH0XL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 19:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Qqo/pjnpPqSArdKBusMzlJLI1z8MScGrZBeTBfd8Psl9sKgupHqUrYx2f7OY2VYuqt
         vtzYX3AB/LSsWF1PO3Z2As+Ar3U87CxqFLlsfaUsqxZiHwjGYNebUQQZ94FCzKqbpAQC
         EBXb/Lm4J7+lVnHeOY4t19/hlsX+2JPXz5MiE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908271554130.5649@makko.or.mcafeemobile.com>
References: <4A9285FC.8000606@byu.net> <1251202593-3676-1-git-send-email-ebb9@byu.net> 
	<alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com> 
	<4A968FF8.8050109@byu.net> <alpine.DEB.2.00.0908271554130.5649@makko.or.mcafeemobile.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Thu, 27 Aug 2009 16:11:09 -0700
Message-ID: <a36005b50908271611i230f1cd2o69e99ef23d516899@mail.gmail.com>
Subject: Re: [PATCH] open: introduce O_NOSTD
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Blake <ebb9@byu.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 15:55, Davide Libenzi<davidel@xmailserver.org> wrote:
> Can't the handling be done on close(), like (modulo some errno save/restore):

No.  You can have any file descriptor closed when the process is
started.  No close in the process with the special close.
