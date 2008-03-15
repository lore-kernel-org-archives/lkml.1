Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbYCONcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbYCONcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 09:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYCONcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 09:32:14 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:46537 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYCONcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 09:32:13 -0400
From: Chr <chunkeey@web.de>
To: Milan Broz <mbroz@redhat.com>
Subject: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Sat, 15 Mar 2008 14:32:10 +0100
User-Agent: KMail/1.9.9
Cc: David Chinner <dgc@sgi.com>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
       dm-crypt@saout.de
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <47DA44EB.8000307@redhat.com> <200803150108.04008.chunkeey@web.de>
In-Reply-To: <200803150108.04008.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803151432.11125.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+P5JjyGf0xJc52Hg13/HblmGlz/bNKvH9B+lAR
	u3E3ybF8IjgQDM6wDL79WsbV2DMRTWA4t8D5OMyOG03Kv55A6O
	Iv2Z6rbkA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Sat, Mar 15, 2008 at 01:21:04AM +0100, Ulrich Lukas wrote:
>> With that patch applied, writing seems to work again.
> 
> Current version of the patch is below.  It's still not quite finished.
>
:-/, both patches freezes here... 

I'll try to revert:

commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
dm crypt: use async crypto

dm-crypt: Use crypto ablkcipher interface
Move encrypt/decrypt core to async crypto call.

maybe it isn't the async stuff after all..

>> Btw, is this a regression because of the changed 2.6.25(-rc) code or is
>> it just a coincidence that it worked before?
>
>Introduced during code changes to support async crypto interface.

Regards,
	Chr
 
