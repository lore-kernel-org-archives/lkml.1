Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbYGBQ3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbYGBQ3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYGBQ3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:29:23 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:18862 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbYGBQ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:29:22 -0400
Date: Wed, 2 Jul 2008 18:28:32 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
       Kay Sievers <kay.sievers@vrfy.org>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/04] s390: bus_id -> dev_name conversions
Message-ID: <20080702182832.1a087e8d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080702154630.GA31083@kroah.com>
References: <20080702154630.GA31083@kroah.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 08:46:30 -0700,
Greg KH <greg@kroah.com> wrote:

> @@ -529,7 +529,7 @@ cio_validate_subchannel (struct subchann
>  	}
>  	mutex_init(&sch->reg_mutex);
>  	/* Set a name for the subchannel */
> -	snprintf (sch->dev.bus_id, BUS_ID_SIZE, "0.%x.%04x", schid.ssid,
> +	snprintf (dev_name(&sch->dev), BUS_ID_SIZE, "0.%x.%04x", schid.ssid,
>  		  schid.sch_no);
> 
>  	/*

This hunk does not make much sense. Better just leave it alone until
the dev_set_name()/init_name conversion later.
