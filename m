Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0BFUTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 15:19:12 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:49234 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0BFUTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 15:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Cy0B0AjReQAaTGWB92/fKgbxm/uIe4MNqcmQOsfY50Tr7xxa/tJ+7AMftU7ciTgwda
         2XbELoq5zf9xUqcmfLVNuARUmj2RhgXSfTbb/M1vDf+m1zVCalwmrAaslVeShZUv+LES
         CM4fSf1Ei7L0dZ3L9f6+YTO1Z4FeU68T1TIPg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Some fixes and cleanups for DMFE nework driver
Date: Sat,  6 Feb 2010 22:18:56 +0200
Message-Id: <1265487542-4447-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently put out of the closed my old davicom card and found out
that it doesn't work in my new PC.

Here are few fixes and coding style cleanups for this driver

Without patch #3 the card refuses to work at all here.

First patch is quite large, but it doesn't add any functionality but
makes whole driver pass checkpatch.pl

I also update and fix my own code for suspend/resume and WOL.

Best regards,
	Maxim Levisky

