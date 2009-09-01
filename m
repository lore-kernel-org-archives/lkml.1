Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZIALyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZIALyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZIALyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:54:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbZIALyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:54:11 -0400
Message-ID: <4A9D0B5F.9030108@redhat.com>
Date: Tue, 01 Sep 2009 13:54:07 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: device-mapper cannot open devices with identical
 uuids anymore
References: <20090831115245.GA23044@darkside.12.kls.lan>
In-Reply-To: <20090831115245.GA23044@darkside.12.kls.lan>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mario 'BitKoenig' Holbe wrote:
> Hello,
> 
> somewhere between 2.6.26 and 2.6.30 device-mapper stopped being able to
> open multiple devices with the same UUID:

This is not related to kernel at all.

cryptsetup since 1.0.7 just started to set UUID for device and kernel 
device-mapper never allowed device with the same UUID.

See http://code.google.com/p/cryptsetup/issues/detail?id=34
(also for workaround, next version will have --disable-uuid option)

Milan
--
mbroz@redhat.com

