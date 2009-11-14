Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZKNQyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZKNQyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 11:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZKNQye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 11:54:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:63266 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZKNQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 11:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=xixU9wK0oRGyzLJvg0ZF4WCkCO/xJ88yYL2Z68hGyPhHhm90RTDMCxiKhUkBq8J7r1
         o5tiIrXsyTn3PFNdQ2CORWucMGELXTbJCZKICmEPaSkUOUSJMBe6MEP8tZT62c22A7OA
         GXfV4lOvGK2QsnlF78vrQm/m615cnv9DiClOE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [PATCH] libata: prepare for removal of experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 17:53:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200911141537.19068.bzolnier@gmail.com> <4AFED444.5020201@gmail.com>
In-Reply-To: <4AFED444.5020201@gmail.com>
MIME-Version: 1.0
Message-Id: <200911141753.37935.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009 17:01:08 Robert Hancock wrote:
> On 11/14/2009 08:37 AM, Bartlomiej Zolnierkiewicz wrote:
> > Push experimental tags to host drivers that still need it so we can
> > remove the "global" experimental tag for PATA drivers.
> >
> > I hear that some issues are being worked on but the patch reflects
> > the current situation and we can trivially update status of affected
> > host drivers after new fixes are merged.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> 
> I don't think that the problems you've mentioned fit the definition of 
> the EXPERIMENTAL tag - it means that the driver isn't likely suitable 

I guess you've read bugzillas so if you still think that EXPERIMENTAL
is not justified at least for some drivers than we really have nothing
to talk about anymore..

> for general use. Given that those drivers are probably used by 
> significant numbers of people successfully in various distributions I 
> don't think this is likely to be the case. There may be bugs but 
> non-experimental does not imply bug free.

Hardly a technical argument.

You know that staging drivers are successfully used by
"significant numbers of people successfully in various distributions"?

:)

zbr explained the problem with the kernel development process with more
class than I would ever be able to so I will just save everybody's time..

-- 
Bartlomiej Zolnierkiewicz
