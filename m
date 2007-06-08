Return-Path: <linux-kernel-owner+w=401wt.eu-S1030454AbXFHNLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030454AbXFHNLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968907AbXFHNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:09:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968518AbXFHNJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bo/rjRwx55Py7GUcvK4jGoKbh4JaSBM8kLX2Doy4RjTOmaWzQD4XtLOkhCjlgchQzMsKlLvX7hEgrIHbD1fr18wdNPF5GrI8YTyihS2TGdOnezleX0oGkuVUYbLHD6XhXZwbA2h6t8NqSR4zLidfUIssX9G//p8nTNZWKUWTcIQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH pata-2.6 fix] hpt366: disallow Ultra133 for HPT374
Date: Fri, 8 Jun 2007 14:44:12 +0200
User-Agent: KMail/1.9.6
Cc: wildy@petra.hos.u-szeged.hu, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200706062353.28707.sshtylyov@ru.mvista.com>
In-Reply-To: <200706062353.28707.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081444.12625.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007, Sergei Shtylyov wrote:
> Eliminate UltraATA/133 support for HPT374 -- the chip isn't capable of this mode
> according to the manual, and doesn't even seem to tolerate 66 MHz DPLL clock...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
