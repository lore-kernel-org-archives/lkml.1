Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbYFUT4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbYFUT4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYFUT4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:56:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:28310 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYFUT4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=TFhuLlF+C2V1NoBA7ytklFtCThTEgk3ZMtm2aPlurdTg0CUnwwHzIX+y9lxeeQHi5I
         VOWX9ImVDSHZPM02Dv6ZdN70gj7bNPRzlIm3qsQUs/DaC6G8rK9JX41h7VdgLaNgmHx1
         oOqkz+dnZ7cXHr618+fF/jYa/f4qxorWkNXAA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/4] ide: filter out invalid transfer mode values in set_xfer_rate()
Date: Sat, 21 Jun 2008 21:57:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806212120.41514.bzolnier@gmail.com> <485D589B.5030105@ru.mvista.com>
In-Reply-To: <485D589B.5030105@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806212157.42772.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > Filter out invalid transfer mode values (0x02-0x07) in write handler
> > for obsoleted /proc/ide/hd?/settings:current_speed setting.
> >
> > While at it:
> >
> > * Use XFER_UDMA_6 define.
> >
> > Suggested-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Sergei, IIRC that it is what you were suggesting some time ago.
> >   
> 
>    Maybe I did. :-) But I don't see what that gives to us now...

One free IDE_HFLAG_ host flag (in patch #4/4)!! :)

[ I just went through backlog of lower-prio TODO items. ]
