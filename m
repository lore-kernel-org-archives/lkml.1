Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYCOVfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYCOVfG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYCOVe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:34:56 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53384 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYCOVez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:34:55 -0400
From: Chr <chunkeey@web.de>
To: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Sat, 15 Mar 2008 22:34:52 +0100
User-Agent: KMail/1.9.9
Cc: David Chinner <dgc@sgi.com>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
       dm-crypt@saout.de
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de>
In-Reply-To: <200803151432.11125.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803152234.53199.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+ozmL2ntcEq6t5jPrmajKYBbwfE/rRvw9Ictu8
	9iB2tKTUwwGbAD+D6Mmrh/RL1NUEi9ZoDgI03LbQ2XRpP3lPsO
	UXoi/ECFI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 14:32:10 Chr wrote:
> reverted:
>
> commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
> dm crypt: use async crypto
>
> dm-crypt: Use crypto ablkcipher interface
> Move encrypt/decrypt core to async crypto call.
>

well.... it's much better now, without the async interface. 
Christian Kajau, can you confirm it too? 

Regards,
	Christian
  



