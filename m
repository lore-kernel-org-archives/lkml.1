Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZAMSnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZAMSnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZAMSm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:42:58 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:14741 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZAMSm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SiVxcYiSZpbR/aIvvPSCH8a5+CEt83U86nd19Ns+0rmRqx+cK+InIdOjEPFdNdqln6
         TKSAKFSzkcOgTHLEjduuJ3wBshWOIjQEiPrEk8RMPRxTaByDeIut40Ync/Coi3O1YZz/
         ssPRBeCwqDSSAe40etdN/QrZeTKCcr9rheaJc=
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
 userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
In-Reply-To: <20090113183456.GA14470@localhost>
References: <20090113183456.GA14470@localhost>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 10:37:12 -0800
Message-Id: <1231871832.16221.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 21:34 +0300, Cyrill Gorcunov wrote:
> Impact: cleanup

> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
>    could use it.

Doesn't this need to be (at least) _COMMAND_LINE_SIZE to avoid
polluting the namespace, not sure it can be changed though as the
horse is already out of the barn.

Harvey

