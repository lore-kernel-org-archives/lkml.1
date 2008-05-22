Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbYEVDfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbYEVDfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYEVDfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:35:14 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:34887 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755285AbYEVDfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:35:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iFwEfWO3RSs9vsKdro3tAyW0oy4pqLihBUueDRUcWu46SNa5RP4Spw2AV3qC8LnZgODGrAp0dbWPlBgCXik3UGIdXNlJG5sM7SvrliV9TxRR+PYCCPOGE0Vo/fu1/+b1KH/uBa5BCNIVOD2hhoWXAsKH3N/qsLhZWhdOD9yKArI=  ;
X-YMail-OSG: BC6I9zIVM1kUGNymThD0OVaSWZNGPZYoeIGyP1vXdYwtRhteseOOIFvRf3KIeTno12Bbstan_c4F3810UW_WFDSPI_2m3NYcewENFmuEGeuIqtRWDH1K6UKlKuDtZt.6VvQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH/RFC] spi: Change modalias from a pointer to a character array
Date: Wed, 21 May 2008 17:03:25 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
References: <20080509173146.2932.16141.stgit@trillian.secretlab.ca>
In-Reply-To: <20080509173146.2932.16141.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211703.25822.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2008, Grant Likely wrote:
> This patch changes modalias from a 'const char *' to a fixed char array.
> By copying the modalias string instead of referencing it, the dependency
> on the spi_board_info structure is eliminated and an outside caller does
> not need to maintain a separate spi_board_info allocation for each device.

Looks fine to me.

