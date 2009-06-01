Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZFAM7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZFAM7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZFAM73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:59:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:36150 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZFAM72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=APaMVpPA+yOmxb7LEYE5MFBgUkJ/c+9Ul4IKxV3oaPq0JmzIpuCdgygdqMpuxPQaO2
         7U4noCDVoR5bD+tPSg2th5YwcnkQ2PlvHsMrGmsxfZcrpvVdzjSZwk45xGNaQ2vDlaRr
         grx7C1JwuCVdjv0W4zutVwkmudmftCoCgwGng=
MIME-Version: 1.0
In-Reply-To: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
Date: Mon, 1 Jun 2009 08:59:29 -0400
Message-ID: <87f94c370906010559k4f2694cbv4023129c7b0cbc31@mail.gmail.com>
Subject: Re: [PATCH 0/4] partitions/ide: improve Host Protected Area handling
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 10:39 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
<snip>
> Additionally HPA can also
> be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
> to disable HPA on /dev/hda).

If we use that parameter on older kernels, is it just ignored?  I'm
hoping I can just make that a default for my live CDs, etc..

Also, how is that handled in libata?  (ie. we typically want to force
exposing the HPA regardless of driver selection.)

Alan, given your emphatic ack, is libata likely to follow the same
model.  Any chance we could have a single boot param that handled both
drivers?  I mean instead of having 2 module params.

Thanks
Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
