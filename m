Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZBFC3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZBFC3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZBFC3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:29:14 -0500
Received: from web33401.mail.mud.yahoo.com ([68.142.206.133]:42674 "HELO
	web33401.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752592AbZBFC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:29:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=QceXEfUAGec6Za251A/tZVD6T1V4djHjjnwuo6h0HqCUEzuBfo11m6T7rKWYh17bFZ44ZnCynv56cyKOO74O0EsSl+74yL1V/ehLLgZQOR2zfd++aFe+/DLYdxukZpPiveVX4y+idbrOLDvaKkgd0CPexegyLr7ityC8z4mgN/E=;
X-YMail-OSG: OYQ4wywVM1nXw7kVn9hfnjPbRyATNe9D5mVUnNKL6oOl.lSdGPriz2KgYmHYmF4LygUcLHDtoH_42tH4ThQG.SyTt6yyRofHqKFiKVE4TP64EuMUblJYC1P1x0JZQC1Aer3h8E0GOaSDmpU04VblWudXHVsA3.PenHmXU2jbiivVhQf8hpeFmJSgrR28nxTLJjnr4zN69M8WdnV65p_.Q_QgtA--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 5 Feb 2009 18:29:11 -0800 (PST)
From: Vira <sri1369_s@yahoo.com>
Reply-To: sri1369_s@yahoo.com
Subject: Re: Mapping non-page aligned data to user
To: linux-kernel@vger.kernel.org
In-Reply-To: <498B83EA.4040608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <242952.40744.qm@web33401.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to map DMAed packets directly to contiguous user buffer (avoiding the copy)- thinking of how to skip the packet headers here.

Thx,
-- vira

--- On Thu, 2/5/09, Robert Hancock <hancockrwd@gmail.com> wrote:

> From: Robert Hancock <hancockrwd@gmail.com>
> Subject: Re: Mapping non-page aligned data to user
> To: linux-kernel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Date: Thursday, February 5, 2009, 4:27 PM
> Vira wrote:
> > Hi, 
> > Is there a way to map a non-page aligned kernel
> physical address to user virtual address? remap_pfn_range
> and vm_insert_page operate only on page-aligned physical
> addresses.
> > 
> > If there is no such support, would it be too
> complicated to try out
> > writing something on my own to map non-page aligned
> addresses (the data
> > size is under my control - so I can make that a
> multiple of page size)?
> > 
> > Any suggestions appreciated.
> 
> The CPU, and therefore the kernel, couldn't ensure that
> the user doesn't write outside the mapped region of
> kernel memory if it's not page aligned (the access
> control is page granularity only). That seems like it would
> be a show-stopper in most cases.
> 
> What exactly is it you're trying to achieve with this?
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      
