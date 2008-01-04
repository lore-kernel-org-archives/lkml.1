Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYADVeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYADVeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYADVd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:33:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42633 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYADVdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nhd9ysjvcRdZ7aRW5b7GlUZowJD6JsaGcSZSZykoDOiAoCtuaLkQKFNhok80pEOPKroInKxV+3T1tp7434XMs4OZjlDiMQvaciX1EPA9QbTADVZsokAP7BXwWGXNytx5OX5T7TPUyeGHaJRIIaTg+fRfiq0NNH+JClRzUMvb2sU=
From: Alessandro Guido <alessandro.guido@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Kohjinsha sleep problems
Date: Fri, 4 Jan 2008 22:33:44 +0100
User-Agent: KMail/1.9.7
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080101231955.GA1931@ucw.cz>
In-Reply-To: <20080101231955.GA1931@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042233.44827.alessandro.guido@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il Wednesday 02 January 2008 00:19:55 Pavel Machek ha scritto:
> Hi!
>
> On kohjinsha, wakeup code does not seem to be reached at all. I tried
> looking around FACS, but it seems very empty:
>
> ...

The same on my laptop:

FACS @ 0x2fefafc0
  0000: 46 41 43 53 40 00 00 00 62 12 00 00 00 00 00 00  FACS@...b.......
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................


I've never been able to resume from STR with Linux (works with Windows Vista). 
STD works, although I have to press the power button in order to resume.
