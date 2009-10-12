Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbZJLQtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbZJLQtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbZJLQtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:49:01 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33294 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbZJLQtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=r2oF2vsFkNY6l/95Axsi5clzzWvlLnsQ70PKAGQiHYz5KnfG8HB3IJnoW2/znzkHoi
         eOtXvPIRJuBBPHxBeDeQbwA3d6P8msSl/njQ9v+wJchWobUoG9Cqr7vZEnqEfcE4p4W7
         56se2NXhzEQyRIGy14QgJtpnmnWakJjJwm86E=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: lkml@makubi.at
Subject: Re: DHCP and iptables
Date: Mon, 12 Oct 2009 18:48:44 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20091012183441.64616r9da17njyww@www.issp.eu>
In-Reply-To: <20091012183441.64616r9da17njyww@www.issp.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910121848.45005.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, lkml@makubi.at wrote:
> The last few days I have been wondering about the fact, that I get an IP
> address via
> DHCP if all chains at iptables are set to drop and no accept rules set.
> 
> Does this happen on purpose?

DHCP is an ethernet protocol, not an IP protocol, so you have to use
ebtables instead of iptables to filter it.

	Arnd <><
