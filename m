Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZAXCds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZAXCds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 21:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbZAXCdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 21:33:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:27107 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZAXCdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 21:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vIqnrIWB2on09rdN7v/orD+PQZIITmbcq6/xbxIZqh4RlyH8alk3VaPnb06Ec7gAlZ
         Xz/evMTf6OxlJzbgLNUMP/8qmh0wx5znsm/1PFu1+dve4DDBoZ8HEJUW58M10tZr6Xwp
         PJmzUpT/wJS4OSKQlU727KzrRKUJ2pMTnjNGg=
MIME-Version: 1.0
In-Reply-To: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
Date: Fri, 23 Jan 2009 21:33:37 -0500
X-Google-Sender-Auth: d59d75b56fafa0d2
Message-ID: <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com>
Subject: Re: [RT] [RFC] simple SMI detector
From: Lee Revell <rlrevell@joe-job.com>
To: Jon Masters <jcm@redhat.com>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 5:55 PM, Jon Masters <jcm@redhat.com> wrote:
> Here's a simple SMI detector we've been playing around with internally.
> In case anyone wants to play with it, and especially help clean it up :)
>
> SMI events are particularly unhelpful on Real Time systems because we
> effectively have the CPU stolen from under us. We can't prevent this
> easily without BIOS vendors/system vendor co-operation, but we can help
> to diagnose and log that these are occuring...which can be very helpful
> too.
>

FYI the RTAI project has a patch to allow disabling of SMI:

https://listas.upv.es/pipermail/rtlinuxgpl/2007-April/000609.html

Lee
