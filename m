Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbZJMRiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbZJMRiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760732AbZJMRiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:38:01 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44465 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbZJMRiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:38:00 -0400
Subject: Re: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support
 during the FW boot-up and fixed the 64 bit sense buff error.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Austria, Winston" <Winston.Austria@lsi.com>,
       "Mukker, Atul" <Atul.Mukker@lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C6861F3@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119D7@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C512407@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861F3@cosmail02.lsi.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 12:37:22 -0500
Message-Id: <1255455442.2855.230.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 14:52 -0600, Yang, Bo wrote:
> RESUBMIT:
> 
> Add the 3 mins support during the FW boot-up to the driver.  Also add the fix for the 64 bit sense buff error.

OK, so this one has to be split ... that's a timing enhancement mixed
with a bug fix which seems to be very real and need backporting

James


