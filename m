Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbXLXIFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbXLXIFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 03:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXLXIFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 03:05:13 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:2762 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbXLXIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 03:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Zyysl0Isc4yLF7fla/222dT+b1lm181MhgMon1r1uXt/IuwAclvnK2SF3Xhl53TzZ9b0lkh61wYLqt4gOUYF8rwp98ph+rHqcQ/fbj2jGJ7mY6yG3cAIIWA244vs3ZijgSWKG4vLDgJum5iH1k99DgZoDcdM72ZInHx9B2F7+wY=
Message-ID: <d2a348dd0712240005h1a76c579t9d6270e1bc7ef527@mail.gmail.com>
Date: Mon, 24 Dec 2007 00:05:11 -0800
From: "raki john" <raki4652@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: relation between mmc_request, mmc_data and mmc_command
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
what is the relation between mmc_request ,  mmc_data and mmc_command .
(I am new SD driver development, and I  am working on 2.6.22.1)
when mmc core layer calls  Host controllers request function (member
of  struct  mmc_host_ops), it passes mmc_request structure   to
driver's request function.

1)mmc_request has three members
    mmc_command * cmd
    mmc_data *  data
    mmc_command * stop

2) mmc_data has
mmc_command * stop
 mmc_request *  mrq


3) mmc_command has
   mmc_data *data
  mmc_request *mrq


Does  mmc_requeest->stop is equal  to mmc_request->data->stop ?

Does  mmc_request   is equal  to mmc_request->data->mrq ?

Does mmc_request->data   is equal  to   mmc_request->cmd->data ?

Does mmc_request   is equal  to mmc_request->cmd->mrq  ?


I think Stop command which is part of mmc_request is used for sending
stop command after Multi Block write. is this correct. If stop command
fails(CRC fail, timeout), does this mean card  write failed.



 Thanks In Advance  for your help

--
Thanks
raki
