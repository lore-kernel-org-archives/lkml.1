Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbYBNQEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbYBNQEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYBNQDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:03:46 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50344 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbYBNQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:03:44 -0500
Subject: Re: [Bluez-devel] [PATCH 14/14] net/bluetooth/hci_core.c: Use
	time_* macros
From: Marcel Holtmann <marcel@holtmann.org>
To: BlueZ development <bluez-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org,
       =?UTF-8?Q?S=2E=C3=87a=C4=9Flar?= Onur <caglar@pardus.org.tr>,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <1203003412-11594-15-git-send-email-caglar@pardus.org.tr>
References: y  <1203003412-11594-15-git-send-email-caglar@pardus.org.tr>
Content-Type: text/plain; charset=utf-8
Date: Thu, 14 Feb 2008 17:03:51 +0100
Message-Id: <1203005031.7664.474.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.
> 
> So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly
> 
> Cc: bluez-devel@lists.sf.net
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

since this is full serious of patches, I am not sure if it should go via
the subsystem maintainers or better applied as whole. In case of Linus
or Andrew decide to take them all at once and push them, this on is
acked by me.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


