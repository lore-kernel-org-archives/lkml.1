Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbXJQNen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbXJQNen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 09:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXJQNef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 09:34:35 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:37395 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXJQNef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 09:34:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Phil Lello <phil.lello@googlemail.com>
Subject: Re: USB Problems: HP ScanJet 5300C SET_ADDRESS fails
Date: Wed, 17 Oct 2007 15:34:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <47160B7F.2040805@gmail.com>
In-Reply-To: <47160B7F.2040805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171534.38185.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 17 Oktober 2007 schrieb Phil Lello:
> I've been looking into a problem with my HP ScanJet 5300C not being 
> detected by the USB stack, with a 2.6.20 kernel.

This device is known to crash when string descriptors are requested.
The current kernel has a quirk entry for this device.

	HTH
		Oliver

