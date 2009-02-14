Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZBNTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZBNTCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 14:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZBNTCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 14:02:08 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:58479 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZBNTCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 14:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=fkDeNVdsYkhutPBgKAnTaCFP+4mA28hL7ayws32w1g43fqU/y8h0ye5ngGIJmeaVnA
         oxFS0XvawHO/5cQfVsSqr5lJ23AUf4ApWHjjObwyE7Vm88u89sHfS7I7AmfiTC/FKD6E
         mAFIaDIat8d4Uj2WaotPJXlp15XJ5SVyUmFfQ=
Message-ID: <49971528.4080405@gmail.com>
Date: Sat, 14 Feb 2009 13:02:00 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Michael Riepe <michael.riepe@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: install firmware in a kernel-dependent directory
References: <4996B838.2070205@googlemail.com>
In-Reply-To: <4996B838.2070205@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Riepe wrote:
> Currently, make firmware_install puts all firmware blobs in
> /lib/firmware. If you have several kernel versions installed, they will
> overwrite each other's files, which may lead to problems if the blobs
> eventually change. I think it would be better to use a separate
> directory for every kernel version, like /lib/firmware/$(uname -r) or
> /lib/modules/$(uname -r)/firmware (the latter is my favorite).
> 
> In either case, only a minimal modification in /lib/udev/firmware.sh is
> required to make it look in the new directory first.
> 
> Comments?

Seems reasonable to me, it seemed rather bizarre to me that this wasn't 
done in the first place..
