Return-Path: <linux-kernel-owner+w=401wt.eu-S1760569AbZJMQtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbZJMQtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbZJMQtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:49:15 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:32558 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbZJMQtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=BnvsZx+HoJQKIw9xsnuUL0scoh21d09p2XxtTCOOvu5x0Nz4ARcM8GsZhSiMjYeDMu
         wlaaf/gKEjKNebqmot55cKutZIElLLE6g14AxMkwHeexte4B0DYuQaSraqRM5Tjk/x8I
         +To4ZBAiACM+H18JqjZC1iZKCxMePwSRL+oOw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Tue, 13 Oct 2009 18:44:58 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00292-g0b20633; KDE/4.3.1; x86_64; ; )
Cc: linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr>
In-Reply-To: <4AD46380.9020308@pardus.org.tr>
MIME-Version: 1.0
Message-Id: <200910131844.58983.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 13 October 2009 13:24:48 Ozan Çağlayan wrote:
> Hi,
> 
> In 2.6.31, there are USB device IDs common between both drivers. Should
> a distribution enable both drivers? What do you suggest? Are there any
> *known issues* stuff for one of them?

My advice to distributions for such situations is to ship both but make
one driver the default one.  This provides users with better overall
hardware coverage and flexibility.  Additionally by providing the ability
for direct comparison of both drivers it makes driver authors/maintainers
try really hard at making the final solution work for everybody (instead
of just making it work for their needs only etc.).

Best regards,
Bartlomiej
