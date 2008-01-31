Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbYAaQjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbYAaQjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbYAaQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:39:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41921 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAaQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:39:10 -0500
Date: Thu, 31 Jan 2008 17:39:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
In-Reply-To: <47A1C0A5.7090303@panasas.com>
Message-ID: <Pine.LNX.4.64.0801311736110.4864@fbirervta.pbzchgretzou.qr>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
 <47A1ABF8.4050408@upb.de> <47A1C0A5.7090303@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jan 31 2008 14:35, Boaz Harrosh wrote:
>
>Thanks, Perhaps someone else then. 
>Anyone with gdth HW that can test patches?

Is bisecting down the existing chain and finding the bad commit 
sufficient? (I also take new patches.)

>Your lspci said: "Intel Corporation RAID Controller" Matthew
>is there a gdth card lying around in an Intel lab near you?
>
>James do we need to mark gdth BROKEN for 2.6.24 and higher?

I say revert it for the time being.
