Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbZJGX05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbZJGX05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbZJGX05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:26:57 -0400
Received: from mail-yw0-f196.google.com ([209.85.211.196]:56109 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbZJGX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:26:50 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 19:26:50 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=J8C1dr1xqNvHLNTCRVKPTFRi+/AE7+uBhEWBjZLwJ2nNnNZG1K0odPHFr+xGgFaqvM
         wOCiIhyEpHIR5Pn4JBdWWXE/0occb7XX/LQHmRjjbk7jVjO2KqS87pXDIo1jaDDLxt82
         o1TvsJhcDGAQisgXPBHwdIFZwPcRB3jaA0IDM=
MIME-Version: 1.0
In-Reply-To: <haj471$fn8$1@ger.gmane.org>
References: <haj471$fn8$1@ger.gmane.org>
Date: Wed, 7 Oct 2009 18:18:05 -0500
X-Google-Sender-Auth: 96644668382202d3
Message-ID: <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 5:22 PM, Jack Byer <ojbyer@usa.net> wrote:
> I have a CD of a commercial software program that I am attempting to run
> under wine. The CD works without problems under Windows, but when I mount
> it on linux the file system appears to be empty (no files or
> directories). The drive is capable of reading the CD because "strings
> /dev/cdrom" works.
>
> What would I need to do in order to troubleshoot this problem?

Maybe try mounting with the "-o unhide" option. Or maybe it is a
multi-session disc?
