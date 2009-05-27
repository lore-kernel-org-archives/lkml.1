Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbZE0FAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbZE0FAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZE0FAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:00:24 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:52656 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZE0FAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:00:23 -0400
X-Greylist: delayed 85779 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 01:00:23 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OV1o5KHFvBAeYJzIfEateAWjZKL5QbqeDo4eNWSQo1IcLOmTjaa23OzkjC+h009uf1
         gPTzaFocRPcruwP2ckZIBQTFXFbbvIX634lBb/9FbgMbUxVuYFo+EfrbLrl0gzpEMmdt
         DTo+EG0IlqMYBk0wWPFPrhYpWbheMkG5tbs2w=
Subject: Re: [PATCH v3] MFD: PCAP driver
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <1243399356.2263.46.camel@brutus>
References: <1243399356.2263.46.camel@brutus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 May 2009 01:59:58 -0300
Message-Id: <1243400398.2263.51.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Qua, 2009-05-27 às 01:42 -0300, Daniel Ribeiro escreveu:
> +	/* redirect interrupts to AP, except adcdone2 */
> +	if (!(pdata->config & PCAP_SECOND_PORT))
> +		ezx_pcap_write(pcap, PCAP_REG_INT_SEL, PCAP_IRQ_ADCDONE2);

Just an amendment here, should be (1 << PCAP_IRQ_ADCDONE2), I will fix
this for v4 after I get comments on this version.

Sorry for the noise. :)

-- 
Daniel Ribeiro

