Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603AbZH1F7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbZH1F7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 01:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZH1F7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 01:59:19 -0400
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:30763 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751099AbZH1F7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 01:59:18 -0400
X-Yahoo-Newman-Id: 6855.35346.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=t5uTMv+YopqbZMeMYPMXztSVRb0DPXTllQ0Vj0ZwTd89iVkDpqMohrEOV3qEEBOP+bK9W6iz3Hrklb7On31N1uiV5DeCHCwy2hZrR0fDOvZ41abRVfWyQDDZCyKxCRNiQZRVzcyFfAYX1tluB+abGfpDdcKKNP3hJOHsRJsEFZU=  ;
X-YMail-OSG: ljTDTyUVM1nFU1TbnGNsUTjUbAdQQ8Dbt3tZ39L1XtIgk54nWnpXAEwrVFEIukwj1dc85qFOwQgvDMQuDnRGUDh35YekZCxIc6ntSghfAa.xw9LZaLCEuwQ_rtZWFQL6Oahbb.u8Bb57LD2EKy4GvRZ_KyA57G8qNfqCM1km0bFlorv2X.uTrB6W2JJK.uCOeJWL1prKiUx795EGnFiPVbk0aJdMKOSBJR1Lr2RixQtMPQAsnHAfIuZSIAvPWSoTbyYaWByHuqX6VvHljtm7UfpAs.eJ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH v2 0/8] spi_mpc8xxx: Add support for DMA transfers
Date: Thu, 27 Aug 2009 21:41:59 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
In-Reply-To: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908272141.59796.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009, Anton Vorontsov wrote:

> - Fix build issues in fsl_qe_udc;
> - Some minor cosmetic changes in "Add support for QE DMA mode and
>   CPM1/CPM2 chips" patch.

Hmm ... the first four of these are pure PPC stuff and thus
not appropriate to send as SPI patches; but the second four
depend on them.

So I'll just say

  Acked-by: David Brownell <dbrownell@users.sourceforge.net>

and ask you to merge via the PPC tree.  (And hope that you
verified these are bisectable...)


