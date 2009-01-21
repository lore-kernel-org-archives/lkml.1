Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbZAUBOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbZAUBOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:14:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZAUBNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:13:51 -0500
Received: from web32404.mail.mud.yahoo.com ([68.142.207.197]:42804 "HELO
	web32404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757738AbZAUBNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:13:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=zBvnyWlzogAgp8h94Z7M/KH7AnjBHSEe/pxQuTRviZBzzXoUi/p2NdZ5xC0qPgZXn9LlWxfmdd68QRT6+vQ4rkl0u2SV1RkHS5naKevZjaN6/6EpKuDsr3IQqAB2q646MlOVvAgJ7WFO502EIExZ7CCSCZeolKFeT++fYqQgKbg=;
X-YMail-OSG: Ii5451IVM1mGS0pEi6WZG.LZsy1T4H.dB0UGCZv2Alk.a5v.02jHJ0mAGvC6CDYfweWv1xf3Wr.atzdAg7Oc.MspERcSUSbPeBVD8EbE0tAkAzcib7a58yRoo81P3_DAi2s1O6KTnGbHhKuCsCRsWq5EwwwNkl5A1BQ8u79KS5p0qq83k08qtR2o3zj7
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 20 Jan 2009 17:07:09 -0800 (PST)
From: Anil kumar <anils_r@yahoo.com>
Reply-To: anils_r@yahoo.com
Subject: scsi command timeout_per_command and scsi device timeout
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <521553.39263.qm@web32404.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the relation between scsi_cmd->timeout_per_command and scsi_device->timeout?
I set a timeout value for scsi_device->timeout in slave_configure, but I don't see this value being taken by scsi_cmd->timeout_per_command.

If they are not related, then how can I set command timeout for all commands to my driver to avoid command timeouts.

with regards,
  Anil


      
