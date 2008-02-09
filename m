Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYBIICt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYBIICt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYBIICk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:02:40 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:28054 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752101AbYBIICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:02:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=k1AXJz0Xi7XmOwsz60LFtexSu5DnYvoeg2Unl0GB3rqMiPyVRalMKf0yyqvPXX/iym8+rHa0vjf/yBZp6LARQl4/B6tjiXHRNGUTHvOi8AY2XNLikxj1qoQvl+qPTAgUtFN9wjHzMxdhIrZZ+F1BWSBSl/K2neOOtbDGgO1FzdY=;
X-YMail-OSG: h5L3TT8VM1l_ZaVf77AcezZYa2TcZ2IZEc9G0fDCAf1f8RguB0KPNknPqSNVSenGyOSlmQ--
X-Mailer: YahooMailWebService/0.7.162
Date: Sat, 9 Feb 2008 00:02:33 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] scsi_error: Fix language abuse.
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080208153217.5fc42a50@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <949768.13992.qm@web31801.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 2/8/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> The word "illegal" has a precise dictionary
> meaning of "prohibited by
> law". The error messages are therefore incorrect as so
> far nobody has
> made SCSI violations a criminal offence.
> 
> This corrects scsi to match various other subsystems
> I've slowly been
> ridding of this.
> 
> Pedantically-signed-off-by: Alan Cox
> <alan@redhat.com>

Alan,

In standards and in hardware specs, from which the meaning of
"illegal" is borrowed from (into standards), "illegal" doesn't
necessarily mean "invalid", and cannot be substituted for.
This is exactly why this particular word is used in the ASC/ASCQ
assignments.  It exposes an underlying behaviour.

For example:

> -	{0x2004, "Illegal command while in write capable state"},
> +	{0x2004, "Invalid command while in write capable state"},

Consider this: the command itself can be very perfectly "valid",
e.g. the SCB contents, format, etc., but certainly "illegal".

Similarly for the rest of this patch.

   Luben

