Return-Path: <linux-kernel-owner+w=401wt.eu-S934448AbZJIVpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448AbZJIVpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758903AbZJIVpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:45:14 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:64721 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbZJIVpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=U6CWDOUVg5QdxhCYGweWATRZF7gHZ7IqfmGDB9sZBvQBuKpOARLGdiDeLOcmNL60iV
         ZY3Tua2v+/c9BY3BKhp54SkJpQQPelfmcPxHYfhYLv1GagruBlwVmjotYEGLAV3Ck5kj
         pXxaUfT3ZY/vGU8MZYDxFUCdJF4vkeYccR4s0=
MIME-Version: 1.0
In-Reply-To: <cdb43e8a0910081723v1adeea80p6a1360ae22a3afcf@mail.gmail.com>
References: <haj471$fn8$1@ger.gmane.org>
	 <58965d8a0910071618s2420fed1k4ccde4823e57f756@mail.gmail.com>
	 <haj8uj$fn8$2@ger.gmane.org>
	 <a8e1da0910072255r38f95e59lf9559b4ecd1cc9d2@mail.gmail.com>
	 <cdb43e8a0910080331l1faa426cq9c2e1e0467003ec9@mail.gmail.com>
	 <a8e1da0910080351w4fe8827eyd583eb903748ed92@mail.gmail.com>
	 <a8e1da0910080440u6367cdcbq55f57d6a16d97533@mail.gmail.com>
	 <cdb43e8a0910081723v1adeea80p6a1360ae22a3afcf@mail.gmail.com>
Date: Fri, 9 Oct 2009 16:44:35 -0500
X-Google-Sender-Auth: edcb3e8b4b651e81
Message-ID: <58965d8a0910091444w1d913527u11a1ab896da918ce@mail.gmail.com>
Subject: Re: iso9660 mount problem
From: Paul Hartman <paul.hartman+linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 8, 2009 at 7:23 PM, Jack Byer <ojbyer@usa.net> wrote:
>> So it must be an apple hfs disc, (or hybrid disc?).
>> Maybe you may try mount it as hfs, this problem is not relevant to iso9660.
>
> I can mount the disc as hfsplus but it shows the OS X contents instead
> of the Windows contents.

Looks like Rosetta Stone :) and i think it is hybrid HFS/iso9660. I
can see windows-related filenames in the sample you uploaded, so we
know they are out there somewhere. Maybe try this in your mount
options (thanks google):

mount -t iso9660 -o norock,map=off

Also, if that doesn't work, do you have CONFIG_JOLIET=y in your kernel
.config? Maybe it's needed...
