Return-Path: <linux-kernel-owner+w=401wt.eu-S1762803AbXHOOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803AbXHOOT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbXHOOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:19:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:13476 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbXHOOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RmucCh5WI+0onLlALBVtK6OobCc34II9WGY4nfW/RUHAPSxF5DfkMAt0DJM9nKU6hnlYvT9a3nZUCiL8ZumFeEzwdKYae3DrPnbyGM5xLZf8X7oCkPS4tPZaNw1Fgqbw45ycKwL/3YM1xq9zUxwlstiNZJhgB0hTDOgcQiAKSOs=
Message-ID: <5d6222a80708150719x254627f0k40240ac6450f019c@mail.gmail.com>
Date: Wed, 15 Aug 2007 11:19:44 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 18/25][V3] turn priviled operations into macros in entry.S
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
In-Reply-To: <Pine.LNX.4.58.0708151002001.25252@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11871821854176-git-send-email-gcosta@redhat.com>
	 <11871823042011-git-send-email-gcosta@redhat.com>
	 <11871823151789-git-send-email-gcosta@redhat.com>
	 <11871823273810-git-send-email-gcosta@redhat.com>
	 <11871823373106-git-send-email-gcosta@redhat.com>
	 <11871823673236-git-send-email-gcosta@redhat.com>
	 <11871823782610-git-send-email-gcosta@redhat.com>
	 <11871823892519-git-send-email-gcosta@redhat.com>
	 <11871823991803-git-send-email-gcosta@redhat.com>
	 <Pine.LNX.4.58.0708151002001.25252@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Is the .globl really required here? I would think that the reference in
> the fixup section would be resolved with in the compiling of this object.
>
For the fixup yes, you are right. But I'm using this symbol in
paravirt.c now, to denote the native operation.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
