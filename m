Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbXJKVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbXJKVr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXJKVrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:47:19 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42739
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbXJKVrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:47:18 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] esp_scsi.c: remove __dev{init,exit}
Date: Thu, 11 Oct 2007 17:47:02 -0500
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
References: <200710110552.49129.rob@landley.net> <1192109439.3352.11.camel@localhost.localdomain> <20071011153520.GA16424@stusta.de>
In-Reply-To: <20071011153520.GA16424@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111747.03119.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 10:35:20 am Adrian Bunk wrote:
> Since scsi_esp_{,un}register() are EXPORT_SYMBOL'ed, these functions
> (and the functions they use) can't be __dev{init,exit}.
>
> Based on a bug report by Rob Landley.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Rob Landley <rob@landley.net>

Worked for me...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
